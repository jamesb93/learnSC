// Slicing visualiser
// James Bradbury
// Love in the time of Corona


(
var win, soundFileView;
var soundFile, audioBuffer, slicesArray;
var addSelections, playFunc, stopFunc;
var bufPlayer;
var synths;
var playing, currentSelection, colors, prevColor;
var source, indices;

// Read Files and allocate buffers
source = Buffer.read(
	s,
	File.realpath(
		FluidBufStats.class.filenameSymbol
		).dirname.withTrailingSlash ++ "../AudioFiles/Tremblay-ASWINE-ScratchySynth-M.wav");
indices = Buffer.new(s);

bufPlayer = SynthDef(\noveltySegDemo,{|buf, start, end|
	Out.ar(0, BufRd.ar(1, buf, Phasor.ar(1,  1, start, end)));
}).add;


win = Window.new("NoveltySegmentation",
	Rect(200,200,800,450)).background_(Color.gray);

loadButton.action_{
	FileDialog({ |path|
		soundFile = SoundFile.new;
		soundFile.openRead(path[0]);
		audioBuffer = Buffer.read(server, path[0]);
		soundFileView.soundfile = soundFile;
		soundFileView.read(0, soundFile.numFrames);
   });
};

soundFileView = SoundFileView.new(win)
	.gridOn_(false)
	.waveColors_([Color.white]);


slicesBuffer.loadToFloatArray(action:{|arr|
    slicesArray = arr;
    {  processButton.value_(0);
        addSelections.value(slicesArray)
    }.defer;
});

addSelections = {|array|
	soundFileView.selections.do({|sel, i|  soundFileView.selectNone(i)});
	array.size.do({|i|

		soundFileView.setSelectionStart(i, array[i]);
		soundFileView.setSelectionSize(i, array[i+1] - array[i]);
		soundFileView.setSelectionColor(i, colors[i]);
	});
};


win.front;
)

win.layout_(
	VLayout(

	)
);
