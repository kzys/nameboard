var twitter_node = require('twitter-node'),
    serialport = require('serialport'),
    child_process = require('child_process'),
    q = require('q');

var mecab = child_process.spawn('mecab', [ '-Oyomi' ]);

function katakana(src) {
    var result = q.defer();
    mecab.stdout.on('data', function (data) {
        result.resolve((''+data).replace(/\n$/, ''));
    });
    mecab.stdin.write(src + '\n');
    return result.promise;
}

function hankakuShiftJIS(src) {
    var result = q.defer();

    var nkf = child_process.spawn('nkf', [
        '-s',
        '-Z4'
    ]);
    nkf.stdout.on('data', function (data) {
        result.resolve(data);
    });
    nkf.stdin.write(src);
    nkf.stdin.end();
    return result.promise;
}

var port = new serialport.SerialPort('/dev/tty.usbmodem1d11', {
    baudrate: 9600
});

var messages = [];
setInterval(function () {
    console.log(messages[0]);
    katakana(messages[0]).then(function (s) {
        hankakuShiftJIS(s + ' \n').then(function (bytes) {
            port.write(bytes);
        });
    });
}, 1000 * 10);

var twitter = new twitter_node.TwitterNode({
    user: process.argv[2],
    password: process.argv[3]
});
twitter.addListener('tweet', function (message) {
    messages[0] = message.text;
});

twitter.track(process.argv[4]);

twitter.stream();