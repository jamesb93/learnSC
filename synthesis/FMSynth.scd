(
SynthDef.new(\fm, {
    arg fund1=110,fund2=220,fund3=237,curve= -2.5,envTime=1,amp=1,pitchScale=1,fb1=0.0,fb2=0.0,fb3=0.0;
    var env, out;
    env = Env([1, 0], [envTime], curve:curve);
    out = ThreeOp.ar(
        freq1: fund1 * pitchScale,
        freq2: fund2 * pitchScale,
        freq3: fund3 * pitchScale,
        env1: EnvGen.kr(env, doneAction: Done.freeSelf),
        env2: EnvGen.kr(env, doneAction: Done.freeSelf),
        env3: EnvGen.kr(env, doneAction: Done.freeSelf),
        fb3to2:fb1,
        fb3to1:fb2,
        fb2to1:fb3
    );
    Out.ar(0, out[0]!2 * amp * 0.33);
    Out.ar(0, out[1]!2 * amp * 0.33);
    Out.ar(0, out[2]!2 * amp * 0.33);
}).add;

"Loaded FM Synthesiser"
)