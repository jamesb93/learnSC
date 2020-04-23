//// Playback using buffers loaded from a big folder of sounds ////

(
s.boot;
s.options.numBuffers = 4000;
/*s.options.numBuffers = 21000;
s.options.numBuffers;*/
)


(
var folder;
~src =  Array.new;

folder = PathName("C:/Users/james/Documents/Max 8/Packages/FluidCorpusManipulation/media");
folder.entries.do({
    arg path;
    if (path.extension == "wav") {
        ~src = ~src.add(Buffer.read(s, path.fullPath));
        postln("Loading " ++ path.fileName);
    };
});
postln("---- Samples Loadead ----")
)

(
SynthDef.new(\reader, {
    arg buf, amp=1;
    var sig;
    sig = PlayBuf.ar(1, buf, doneAction:2);
    sig = sig * amp;
    Out.ar([0, 1], sig);
}).add;
)

Synth.new(\reader, [\buf, ~src[3]]);
s.freeAll;
s.meter;

//// ---------------------------------------------------------------- ////