#include <assert.h>
#include <getopt.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>

class AudioPlayer {
	public:
		AudioPlayer();
		~AudioPlayer();
		void play(char const* uri);
		/**
		 * This allows setting the stream type (default:SL_ANDROID_STREAM_MEDIA):
		 * SL_ANDROID_STREAM_ALARM - same as android.media.AudioManager.STREAM_ALARM
		 * SL_ANDROID_STREAM_MEDIA - same as android.media.AudioManager.STREAM_MUSIC
	 	 * SL_ANDROID_STREAM_NOTIFICATION - same as android.media.AudioManager.STREAM_NOTIFICATION
		 * SL_ANDROID_STREAM_RING - same as android.media.AudioManager.STREAM_RING
		 * SL_ANDROID_STREAM_SYSTEM - same as android.media.AudioManager.STREAM_SYSTEM
		 * SL_ANDROID_STREAM_VOICE - same as android.media.AudioManager.STREAM_VOICE_CALL
		 */
		void setStreamType(SLint32 streamType) { this->androidStreamType = streamType; }
	private:
		SLObjectItf mSlEngineObject{NULL};
		SLEngineItf mSlEngineInterface{NULL};
		SLObjectItf mSlOutputMixObject{NULL};
		SLint32 androidStreamType{SL_ANDROID_STREAM_MEDIA};
};

class MutexWithCondition {
	public:
		MutexWithCondition() {
			pthread_mutex_init(&mutex, NULL);
			pthread_cond_init(&condition, NULL);
			pthread_mutex_lock(&mutex);
		}
		~MutexWithCondition() { pthread_mutex_unlock(&mutex); }
		void waitFor() { while (!occurred) pthread_cond_wait(&condition, &mutex); }
		/** From waking thread. */
		void lockAndSignal() {
			pthread_mutex_lock(&mutex);
			occurred = true;
			pthread_cond_signal(&condition);
			pthread_mutex_unlock(&mutex);
		}
	private:
		volatile bool occurred{false};
		pthread_mutex_t mutex;
		pthread_cond_t condition;
};

AudioPlayer::AudioPlayer() {
	// "OpenSL ES for Android is designed for multi-threaded applications, and is thread-safe.
	// OpenSL ES for Android supports a single engine per application, and up to 32 objects.
	// Available device memory and CPU may further restrict the usable number of objects.
	// slCreateEngine recognizes, but ignores, these engine options: SL_ENGINEOPTION_THREADSAFE SL_ENGINEOPTION_LOSSOFCONTROL"
	SLresult result = slCreateEngine(&mSlEngineObject, 
			/*numOptions=*/0, /*options=*/NULL, 
			/*numWantedInterfaces=*/0, /*wantedInterfaces=*/NULL, /*wantedInterfacesRequired=*/NULL);
	assert(SL_RESULT_SUCCESS == result);

	result = (*mSlEngineObject)->Realize(mSlEngineObject, SL_BOOLEAN_FALSE);
	assert(SL_RESULT_SUCCESS == result);

	result = (*mSlEngineObject)->GetInterface(mSlEngineObject, SL_IID_ENGINE, &mSlEngineInterface);
	assert(SL_RESULT_SUCCESS == result);

	SLuint32 const numWantedInterfaces = 0;
	result = (*mSlEngineInterface)->CreateOutputMix(mSlEngineInterface, &mSlOutputMixObject, numWantedInterfaces, NULL, NULL);
	assert(SL_RESULT_SUCCESS == result);

	result = (*mSlOutputMixObject)->Realize(mSlOutputMixObject, SL_BOOLEAN_FALSE);
	assert(SL_RESULT_SUCCESS == result);

}

void opensl_prefetch_callback(SLPrefetchStatusItf caller, void* pContext, SLuint32 event) {
	if (event & SL_PREFETCHEVENT_STATUSCHANGE) {
		SLpermille level = 0;
		(*caller)->GetFillLevel(caller, &level);
		if (level == 0) {
			SLuint32 status;
			(*caller)->GetPrefetchStatus(caller, &status);
			if (status == SL_PREFETCHSTATUS_UNDERFLOW) {
				// Level is 0 but we have SL_PREFETCHSTATUS_UNDERFLOW, implying an error.
				printf("play-audio: underflow when prefetching data\n");
				MutexWithCondition* cond = (MutexWithCondition*) pContext;
				cond->lockAndSignal();
			}
		}
	}
}

void opensl_player_callback(SLPlayItf /*caller*/, void* pContext, SLuint32 /*event*/) {
	MutexWithCondition* condition = (MutexWithCondition*) pContext;
	condition->lockAndSignal();
}

void AudioPlayer::play(char const* uri)
{
	SLDataLocator_URI loc_uri = {SL_DATALOCATOR_URI, (SLchar *) uri};
	SLDataFormat_MIME format_mime = {SL_DATAFORMAT_MIME, NULL, SL_CONTAINERTYPE_UNSPECIFIED};
	SLDataSource audioSrc = {&loc_uri, &format_mime};

	SLDataLocator_OutputMix loc_outmix = {SL_DATALOCATOR_OUTPUTMIX, mSlOutputMixObject};
	SLDataSink audioSnk = {&loc_outmix, NULL};

	// SL_IID_ANDROIDCONFIGURATION is Android specific interface, SL_IID_PREFETCHSTATUS is general:
	SLuint32 const numWantedInterfaces = 2;
	SLInterfaceID wantedInterfaces[numWantedInterfaces]{ SL_IID_ANDROIDCONFIGURATION, SL_IID_PREFETCHSTATUS };
	SLboolean wantedInterfacesRequired[numWantedInterfaces]{ SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE };

	SLObjectItf uriPlayerObject = NULL;
	SLresult result = (*mSlEngineInterface)->CreateAudioPlayer(mSlEngineInterface, &uriPlayerObject, &audioSrc, &audioSnk,
			numWantedInterfaces, wantedInterfaces, wantedInterfacesRequired);
	assert(SL_RESULT_SUCCESS == result);

	// Android specific interface - usage:
	// SLresult (*GetInterface) (SLObjectItf self, const SLInterfaceID iid, void* pInterface);
	// This function gives different interfaces. One is android-specific, from
	// <SLES/OpenSLES_AndroidConfiguration.h>, done before realization:
	SLAndroidConfigurationItf androidConfig;
	result = (*uriPlayerObject)->GetInterface(uriPlayerObject, SL_IID_ANDROIDCONFIGURATION, &androidConfig);
	assert(SL_RESULT_SUCCESS == result);

	result = (*androidConfig)->SetConfiguration(androidConfig, SL_ANDROID_KEY_STREAM_TYPE, &this->androidStreamType, sizeof(SLint32));
	assert(SL_RESULT_SUCCESS == result);

	// We now Realize(). Note that the android config needs to be done before, but getting the SLPrefetchStatusItf after.
	result = (*uriPlayerObject)->Realize(uriPlayerObject, /*async=*/SL_BOOLEAN_FALSE);
	assert(SL_RESULT_SUCCESS == result);

	SLPrefetchStatusItf prefetchInterface;
	result = (*uriPlayerObject)->GetInterface(uriPlayerObject, SL_IID_PREFETCHSTATUS, &prefetchInterface);
	assert(SL_RESULT_SUCCESS == result);

	SLPlayItf uriPlayerPlay = NULL;
	result = (*uriPlayerObject)->GetInterface(uriPlayerObject, SL_IID_PLAY, &uriPlayerPlay);
	assert(SL_RESULT_SUCCESS == result);

	if (NULL == uriPlayerPlay) {
		fprintf(stderr, "Cannot play '%s'\n", uri);
	} else {
		result = (*uriPlayerPlay)->SetCallbackEventsMask(uriPlayerPlay, SL_PLAYEVENT_HEADSTALLED | SL_PLAYEVENT_HEADATEND);
		assert(SL_RESULT_SUCCESS == result);

		MutexWithCondition condition;
		result = (*uriPlayerPlay)->RegisterCallback(uriPlayerPlay, opensl_player_callback, &condition);
		assert(SL_RESULT_SUCCESS == result);

		result = (*prefetchInterface)->RegisterCallback(prefetchInterface, opensl_prefetch_callback, &condition);
		assert(SL_RESULT_SUCCESS == result);
		result = (*prefetchInterface)->SetCallbackEventsMask(prefetchInterface, SL_PREFETCHEVENT_FILLLEVELCHANGE | SL_PREFETCHEVENT_STATUSCHANGE);

		// "For an audio player with URI data source, Object::Realize allocates resources but does not
		// connect to the data source (i.e. "prepare") or begin pre-fetching data. These occur once the
		// player state is set to either SL_PLAYSTATE_PAUSED or SL_PLAYSTATE_PLAYING."
		// - http://mobilepearls.com/labs/native-android-api/ndk/docs/opensles/index.html
		result = (*uriPlayerPlay)->SetPlayState(uriPlayerPlay, SL_PLAYSTATE_PLAYING);
		assert(SL_RESULT_SUCCESS == result);

		condition.waitFor();
	}

	if (uriPlayerObject != NULL) (*uriPlayerObject)->Destroy(uriPlayerObject);
}


AudioPlayer::~AudioPlayer()
{
	// "Be sure to destroy all objects on exit from your application. Objects should be destroyed in reverse order of their creation,
	// as it is not safe to destroy an object that has any dependent objects. For example, destroy in this order: audio players
	// and recorders, output mix, then finally the engine."
	if (mSlOutputMixObject != NULL) { (*mSlOutputMixObject)->Destroy(mSlOutputMixObject); mSlOutputMixObject = NULL; }
	if (mSlEngineObject != NULL) { (*mSlEngineObject)->Destroy(mSlEngineObject); mSlEngineObject = NULL; }
}


int main(int argc, char** argv)
{
	bool help = false;
	int c;
	char* streamType = NULL;
	while ((c = getopt(argc, argv, "hs:")) != -1) {
		switch (c) {
			case 'h':
			case '?': help = true; break;
			case 's': streamType = optarg; break;
		}
	}

	if (help || optind == argc) {
		printf("usage: play-audio [-s streamtype] [files]\n");
		return 1;
	}

	AudioPlayer player;

	if (streamType != NULL) {
		SLint32 streamTypeEnum;
		if (strcmp("alarm", streamType) == 0) {
			streamTypeEnum = SL_ANDROID_STREAM_ALARM;
		} else if (strcmp("media", streamType) == 0) {
			streamTypeEnum = SL_ANDROID_STREAM_MEDIA;
		} else if (strcmp("notification", streamType) == 0) {
			streamTypeEnum = SL_ANDROID_STREAM_NOTIFICATION;
		} else if (strcmp("ring", streamType) == 0) {
			streamTypeEnum = SL_ANDROID_STREAM_RING;
		} else if (strcmp("system", streamType) == 0) {
			streamTypeEnum = SL_ANDROID_STREAM_SYSTEM;
		} else if (strcmp("voice", streamType) == 0) {
			streamTypeEnum = SL_ANDROID_STREAM_VOICE;
		} else {
			fprintf(stderr, "play-audio: invalid streamtype '%s'\n", streamType);
			return 1;
		}
		player.setStreamType(streamTypeEnum);
	}

	for (int i = optind; i < argc; i++) {
		if (access(argv[i], R_OK) != 0) {
			fprintf(stderr, "play-audio: '%s' is not a readable file\n", argv[i]);
			return 1;
		}
	}

	for (int i = optind; i < argc; i++) {
		player.play(argv[i]);
	}

	return 0;
}
