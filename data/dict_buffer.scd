/* SOUND BUFFERS */
(
~folder = PathName("/Users/james/Library/Application Support/SuperCollider/Extensions/FluidCorpusManipulation/AudioFiles");
~soundsArray = Dictionary.new;

~folder.filesDo({
    arg file;
    if((file.extension == "wav"), {
        ~soundsArray.add(file.fileNameWithoutExtension.asSymbol -> Buffer.read(s, file.fullPath.asString));
    });
});
)



(
Routine.run({
    var indices;

    ~loudnessBufs = Dictionary.new;
    indices = Buffer.new(s);

    ~soundsArray.keys.do{|x|
        FluidBufNoveltySlice.process(
            s,
            source:~soundsArray[x],
            indices:indices
        );
        ~loudnessBufs.add(x -> indices);
    }
});
)