
exports.COLORS = {
    'R': 0xFF0000ff, // red
    'r': 0xFF00007f, // red half-alpha
    'G': 0x00FF00ff, // green
    'g': 0x00FF007f, // green half-alpha
    'B': 0x0000FFff, // blue
    'b': 0x0000FF7f, // blue half-alpha
    '*': 0x000000ff, // black
    ' ': 0x00000000, // fully transparent
    'W': 0xFFFFFFff, // white
    '_': 0xFFFFFF01,  // white transparent
    '4': 0x404040ff, // dark grey
    '9': 0x909090ff  // light grey
};

exports.PREMADE = {

    sampleSprite: [
        ' *',
        '* '
    ],

    singleFrameMonoOpaque: [
        'RRR',
        'RRR',
        'RRR'
    ],

    singleFrameMonoOpaqueSpriteAt1x1: [
        'RRR',
        'RR*',
        'R*R'
    ],

    singleFrameNoColorTrans: [
        '   ',
        '   ',
        '   '
    ],

    singleFrameMonoTrans: [
        ' G ',
        'GGG',
        ' G '
    ],

    singleFrameBWOpaque: [
        '*WW*',
        'W**W',
        '*WW*'
    ],

    singleFrameMultiOpaque: [
        'RGBW',
        'WRGB'
    ],

    singleFrameMultiTrans: [
        'RGB ',
        ' RGB',
        '   *'
    ],

    singleFrameMultiPartialTrans: [
        '_G  ',
        '__G ',
        'rgb*'
    ],

    twoFrameMultiOpaque: [
        ['**RR',
         'GG**',
         '**BB'],
        ['RR**',
         '**GG',
         'BB**']
    ],

    threeFrameMonoTrans: [
        ['*  ',
         '   ',
         '   '],
        ['   ',
         ' * ',
         '   '],
        ['   ',
         '   ',
         '  *']
    ]
};
