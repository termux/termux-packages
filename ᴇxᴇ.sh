echo -e "[40;38;5;82m [EXE -  ID] "
read VIPname
echo -e "[40;38;5;82m [EXE - KEY] "
read CHINA
if [[ $VIPname == "EXE"  && $CHINA == "VIP" ]]
then

COUNT=50
fixPUBGM()
{
echo "[version]
appversion=0.17.0.11800
srcversion=0.17.0.11809
" > /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SrcVersion.ini
chmod 660 /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SrcVersion.ini
cp /storage/emulated/0/Android/backups/Paks/*.* /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks
rm -rf /storage/emulated/0/Android/backups
rm -rf /storage/emulated/0/.backups
rm -rf /storage/emulated/0/MidasOversea
rm -rf /storage/emulated/0/supercache
rm -rf /storage/emulated/0/tencent
sleep 10
}
modPUBGM()
{
iptables -I INPUT -s cloudctrl.gcloud.qq.com -j RETURN
iptables -I OUTPUT -s cloudctrl.gcloud.qq.com -j RETURN
iptables -I FORWARD -s cloudctrl.gcloud.qq.com -j RETURN
iptables -I INPUT -s pingma.qq.com -j RETURN
iptables -I OUTPUT -s pingma.qq.com -j RETURN
iptables -I FORWARD -s pingma.qq.com -j RETURN
iptables -I INPUT -s receiver.sg.tdm.qq.com -j RETURN
iptables -I OUTPUT -s receiver.sg.tdm.qq.com -j RETURN
iptables -I FORWARD -s receiver.sg.tdm.qq.com -j RETURN
iptables -I INPUT -s sg.tdm.qq.com -j RETURN
iptables -I OUTPUT -s sg.tdm.qq.com -j RETURN
iptables -I FORWARD -s sg.tdm.qq.com -j RETURN
iptables -I INPUT -s cloud.gsdk.proximabeta.com -j RETURN
iptables -I OUTPUT -s cloud.gsdk.proximabeta.com -j RETURN
iptables -I FORWARD -s cloud.gsdk.proximabeta.com -j RETURN
iptables -I INPUT -s vmp.qq.com -j RETURN
iptables -I OUTPUT -s vmp.qq.com -j RETURN
iptables -I FORWARD -s vmp.qq.com -j RETURN
iptables -I INPUT -s csoversea.mbgame.gamesafe.qq.com -j RETURN
iptables -I OUTPUT -s csoversea.mbgame.gamesafe.qq.com -j RETURN
iptables -I FORWARD -s csoversea.mbgame.gamesafe.qq.com -j RETURN
iptables -I INPUT -s ig-us-sdkapi.igamecj.com -j RETURN
iptables -I OUTPUT -s ig-us-sdkapi.igamecj.com -j RETURN
iptables -I FORWARD -s ig-us-sdkapi.igamecj.com -j RETURN
mkdir /storage/emulated/0/Android/backups
mkdir /storage/emulated/0/Android/backups/Paks
cp /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/*.* /storage/emulated/0/Android/backups/Paks
rm -rf /storage/emulated/0/Android/backup/Paks/map*.*
rm -rf /storage/emulated/0/Android/backup/Paks/res*.*
rm -rf /data/data/com.pubg.krmobile/app_crashrecord
touch /data/data/com.pubg.krmobile/app_crashrecord
rm -rf /data/data/com.pubg.krmobile/files
touch /data/data/com.pubg.krmobile/files
echo ""
echo "[version]
appversion=0.17.0.11800
srcversion=0.17.0.11807
" > /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SrcVersion.ini
chmod 555 /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SrcVersion.ini
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/core_patch_0.17.0.11808.pak
sleep 10
}
cleaner()
{
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/cache
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/ProgramBinaryCache
touch /storage/emulated/0/Android/data/com.pubg.krmobile/files/ProgramBinaryCache
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/tbslog
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/ca-bundle.pem
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/cacheFile.txt
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/login-identifier.txt
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/vmpcloudconfig.json
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/Engine
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/GameErrorNoRecords
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Config/Android/AntiCheat.ini
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/afd
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Logs
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/IGH5Cache
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/ImageDownload
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Pandora
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/*.*cures.ifs.res
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/apollo_reslist.flist
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/filelist.json
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/puffer_temp
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/puffer_res.eifs
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/Paks/PufferFileList.json
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/PufferTmpDir
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/RoleInfo
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/Activity
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/SaveGames/Match
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/StatEventReportedFlag
rm -rf /storage/emulated/0/Android/data/com.pubg.krmobile/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/UpdateInfo
rm -rf /storage/emulated/0/.backups /storage/emulated/0/MidasOversea /storage/emulated/0/supercache /storage/emulated/0/tencent
touch /storage/emulated/0/.backups /storage/emulated/0/MidasOversea /storage/emulated/0/supercache /storage/emulated/0/tencent
rm -rf /data/data/com.pubg.krmobile/app_appcache
rm -rf /data/data/com.pubg.krmobile/app_bugly
rm -rf /data/data/com.pubg.krmobile/app_crashrecord
touch /data/data/com.pubg.krmobile/app_crashrecord
rm -rf /data/data/com.pubg.krmobile/app_databases
rm -rf /data/data/com.pubg.krmobile/app_dex
rm -rf /data/data/com.pubg.krmobile/app_geolocation
rm -rf /data/data/com.pubg.krmobile/app_tbs
rm -rf /data/data/com.pubg.krmobile/app_textures
rm -rf /data/data/com.pubg.krmobile/app_webview
rm -rf /data/data/com.pubg.krmobile/app_webview_imsdk_inner_webview
rm -rf /data/data/com.pubg.krmobile/cache
rm -rf /data/data/com.pubg.krmobile/code_cache
rm -rf /data/data/com.pubg.krmobile/files
touch /data/data/com.pubg.krmobile/files
printf "ᴄʟᴇᴀʀɪɴɢ ᴄᴀᴄʜᴇ & ʟᴏɢ ᴀᴜᴛᴏᴍᴀᴛɪᴄᴀʟʟʏ!\n";
printf "ɴᴏᴡ: ";
date
printf "\n";
}
echo ""
echo " 
                 --[ᴘʀᴏᴊᴇᴄᴛ EXE]--  \n"
echo ""
echo " Loading…"
echo " █▒▒▒▒▒▒▒▒▒"
echo " 10%"
sleep 1
echo " ███▒▒▒▒▒▒▒"
echo " 30%"
sleep 1
echo " █████▒▒▒▒▒"
echo " 50%"
sleep 1
echo " ███████▒▒▒"
echo " 100%"
sleep 2
echo " ██████████ "
sleep 2
echo "🅂🄿🄶 🄾🄵🄵🄸🄲🄸🄰🄻"
sleep 2
echo "    --[𝙺𝙾𝚁𝙴𝙰]✓"--
printf "
╔═══╗╔╗─╔╗╔═══╗╔═══╗╔════╗╔═══╗╔═══╗╔═══╗╔═╗─╔╗╔═══╗
║╔═╗║║║─║║║╔══╝║╔═╗║║╔╗╔╗║║╔═╗║║╔═╗║║╔══╝║║╚╗║║║╔═╗║
║║─╚╝║╚═╝║║╚══╗║║─║║╚╝║║╚╝║║─║║║╚═╝║║╚══╗║╔╗╚╝║║║─║║
║║─╔╗║╔═╗║║╔══╝║╚═╝║──║║──║╚═╝║║╔╗╔╝║╔══╝║║╚╗║║║╚═╝║
║╚═╝║║║─║║║╚══╗║╔═╗║──║║──║╔═╗║║║║╚╗║╚══╗║║─║║║║╔═╗║
╚═══╝╚╝─╚╝╚═══╝╚╝─╚╝──╚╝──╚╝─╚╝╚╝╚═╝╚═══╝╚╝─╚═╝╚╝─╚╝ \n\n";
echo ""
sleep 2
if [ -d "/data/data/com.pubg.krmobile" ];
then
echo "\nʟᴏᴀᴅɪɴɢ...\n"
if [ ! -d "/sdcard/Android/data/backups/ajtdlaspgksjdj" ];
then
if [ ! -f "/data/data/com.pubg.krmobile/lib/libUE4.so" ];
then
echo "ᴘᴜʙɢᴍ ɪꜱ ɴᴏᴛ ɪɴꜱᴛᴀʟʟᴇᴅ ᴄᴏʀʀᴇᴄᴛʟʏ!"
exit 0;
fi
if [ ! -d "/sdcard/Android/data/backups" ];
then
mkdir /sdcard/Android/data/backups
fi
mkdir /sdcard/Android/data/backups/caexe
cp -R /data/data/com.pubg.krmobile/lib/* /sdcard/Android/data/backups/caexe
if [ -d "/data/data/com.termux" ];
then
chmod 777 /data/data/com.termux/files/home/ᴇxᴇ.sh
fi
echo ""
echo "ᴘʟᴇᴀsᴇ ᴡᴀɪᴛ..."
echo ""
sleep 10
fi
else
printf "\nᴘᴜʙɢᴍ ɴᴏᴛ ɪɴꜱᴛᴀʟʟᴇᴅ\nᴘʟᴇᴀꜱᴇ ꜱᴇʟᴇᴄᴛ ᴄᴏʀʀᴇᴄᴛ ᴠᴇʀꜱɪᴏɴ!";
exit 0;
fi
MTPKG='bin.mt.plus'
if [ $(pidof $MTPKG) ];
then
am start -n bin.mt.plus/bin.mt.plus.Main
fi
sleep 2
echo "➪︎ ʀᴇᴘᴀɪʀɴɪɴɢ ᴘᴜʙɢᴍ.....\n"
sleep 7
modPUBGM
printf "\nᴋᴇᴇᴘ ᴘʟᴀʏɪɴɢ & ᴅᴏ ɴᴏᴛ ᴇxɪᴛ\n\n";
printf "\nsᴛᴀʀᴛɪɴɢ ᴘᴜʙɢ ᴍᴏʙɪʟᴇ...\n";
sleep 3
am start -n com.pubg.krmobile/com.epicgames.ue4.SplashActivity
echo "\n"
sleep 40
echo ""
sleep 10
echo "\n ʟᴏɢs & ᴄᴀᴄʜᴇ ᴄʟᴇᴀɴɪɴɢ....."
printf "\n\n";
PACKAGE='com.pubg.krmobile'
while [ $(pidof $PACKAGE) ]
do
cleaner
((COUNT=$COUNT+10))
if [ ! $(pidof $PACKAGE) ]; then
break
fi
sleep 10
done
am force-stop com.cgggxabhi
am force-stop any_.body_.can_.fuck_.tencent_
am force-stop com.bbksb.vdjw
am force-stop com.jqwt
sleep 3
MTMPKG='bin.mt.plus'
if [ $(pidof $MTMPKG) ];
then
am start -n bin.mt.plus/bin.mt.plus.Main
fi
echo ""
echo ""
((final=$COUNT/60))
printf "𝚃𝚘𝚝𝚊𝚕 𝚃𝚒𝚖𝚎\n";
echo $final
printf "ᴍɪɴᴜᴛᴇs\n";
printf "\n\n";
sleep 3
printf "ɢᴀᴍᴇ ɪs ᴅᴇᴀᴅ\nᴀᴜᴛᴏ ᴄʟᴇᴀɴɪɴɢ ᴄᴏᴍᴘʟɪᴛᴇᴅ\n";
printf "\n𝙿𝚁𝙾𝙹𝙴𝙲𝚃-𝙴𝚇𝙴 ʙʏ @𝚂𝙿𝙶_𝙴𝚅𝙸𝙻_𝙾𝙵𝙵𝙸𝙲𝙸𝙰𝙻\n\nᴡᴀɪᴛ!";
printf "\nsᴇᴛᴛɪɴɢ ᴘᴇʀᴍɪssɪᴏɴ";
fixPUBGM
printf "\n\n";
echo "ᴅᴏɴᴇ"
echo "ʏᴏᴜ ᴄᴀɴ ᴇxɪᴛ ɴᴏᴡ"
echo "\n"
echo "│█║▌║▌║ [ ᴄᴏɴᴛᴀᴄᴛ & ꜱᴜᴘᴘᴏʀᴛ ] ║▌║▌║█│ \n"
echo "ᴛᴇʟᴇɢʀᴀᴍ: @𝚂𝙿𝙶_𝙴𝚅𝙸𝙻_𝙾𝙵𝙵𝙸𝙲𝙸𝙰𝙻 "
echo ""
echo "ᴄʜᴀɴɴᴇʟ: @𝙾𝚇_𝙲𝙷𝙴𝙰𝚃𝚂"
echo ""
echo "                   [ 𝙱𝚈𝙴 ]"

elif [ $VIPname != "EXE" ]
then
echo -e "INVALID USERNAME AND PASSWORD
"
else
echo -e "INVALID USERNAME AND PASSWORD
"
fi
