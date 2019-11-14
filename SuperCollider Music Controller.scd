// *************************************************************
// Supercollider Music Controller
// Developed by Tommy Fox
// This project designates preloaded samples
// to be triggered by specific MIDI notes.
// The project provides functionality for triggering
// sounds using changeable sample banks using a MIDI controller.
// It also runs designated samples through delay effects,
// the settings of which can also be controlled via MIDI.
// In order to load the included samples,
// please adjust the filepath in lines 49-64, 77-87, 96-104.
// *************************************************************
(
// connect MIDI controller
MIDIIn.connectAll;

// variable used for incrementing/decrementing delay tempo
~tempo = 1;

// variable for incrementing/decrementing bank
~bank = 1;

// variables used for turning delay on/off
~delay1Toggle = 1;
~delay2Toggle = 1;

// variable used to easily add/delete sample banks
~numberOfBanks = 3;

// begin function load "l"
l = { arg bank;

	// this provides circular bank functionality.
	// after exiting bounds of total banks,
	// loaded bank loops back to the beginning or end
	if (~bank < 1)
	{
		~bank = ~numberOfBanks;
	};

	if (~bank > ~numberOfBanks)
	{
		~bank = 1;
	};

	case
	// load sounds into bank 1
	{~bank == 1}
	{
		~sample1 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/kickDrum1.WAV");
		~sample2 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/snareDrum1.WAV");
		~sample3 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/hat.WAV");
		~sample4 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/crash.WAV");
		~sample5 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/Piano1.WAV");
		~sample6 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/Piano2.WAV");
		~sample7 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/Piano3.WAV");
		~sample8 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/Piano4.WAV");
		~sample9 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/horn.WAV");
		~sample10 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/horn1.WAV");
		~sample11 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/horn2.WAV");
		~sample12 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/horn3.WAV");
		~sample13 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/pianoHi.WAV");
		~sample14 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/piano2Hi.WAV");
		~sample15 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/piano3Hi.WAV");
		~sample16 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/piano4Hi.WAV");

		// delay1 and delay2 preset to on
		~delay1Toggle = -1;
		~delay2Toggle = -1;

		// tempo preset
		~tempo = 1;
	}

	// load sounds into bank 2
	{~bank == 2}
	{
		~sample1 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/kick1.WAV");
		~sample2 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/snare.WAV");
		~sample3 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/hat1.wav");
		~sample4 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/hat2.wav");
		~sample5 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/sample1.wav");
		~sample6 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/sample2.wav");
		~sample7 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/breakDrum1.wav");
		~sample8 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/revHat.wav");
		~sample9 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/vox1.wav");
		~sample10 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/vox2.wav");
		~sample13 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song2/intro.wav");

		// delay1 and delay2 preset to off
		~delay1Toggle = 1;
		~delay2Toggle = 1;
	}

	{~bank == 3}
	{
		~sample1 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/kickDrum1.WAV");
		~sample2 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song1/snareDrum1.WAV");
		~sample3 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/hiHat3.wav");
		~sample4 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/hiHatNew.wav");
		~sample5 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/Gtr.wav");
		~sample6 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/Horn1.wav");
		~sample7 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/Horn2.wav");
		~sample8 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/Horn3.wav");
		~sample9 = Buffer.read(s, "/Users/tom/Documents/SuperColliderController/Song3/Horn4.wav");

		// delay1 preset to on
		~delay1Toggle = -1;

		// delay2 preset to off
		~delay2Toggle = 1;

		// tempo preset
		~tempo = 0.7;
	}
};
// end function load "l"

// SynthDef sample for uneffected sounds
SynthDef("sample", {
	arg bus = 0, buffer = 0, rate = 1, amp = 0.5, pan = -1, startPos = 0, gate = 1, sample;
	var snd, env;
	env = Env.asr(0.01, amp, 0.01).kr(gate: gate, doneAction: 2);
	snd = PlayBuf.ar(
		numChannels: 2,
		bufnum: sample,
		rate: BufRateScale.kr(buffer) * rate,
		startPos: BufFrames.kr(buffer) * startPos,
		doneAction: 2;
	);
	snd = snd * env;
	snd = Pan2.ar(snd, pan);
	Out.ar(bus, snd)
}).add;
// end SynthDef sample

// SynthDef delay1
SynthDef("delay1", {
	arg bus = 0, buffer = 0, rate = 1, amp = 0.5, pan = -1, startPos = 0, gate = 1, tempo = 1, sample;
	var snd;
	snd = PlayBuf.ar(
		numChannels: 2,
		bufnum: sample,
		rate: BufRateScale.kr(buffer) * rate,
		startPos: BufFrames.kr(buffer) * startPos,
		doneAction: 2;
	);
	snd = Pan2.ar(snd, pan);
	snd = snd+CombC.ar(snd, 1, tempo.reciprocal/4, 2);
	Out.ar(bus, snd*amp)
}).add;
// end SynthDef delay1

// SynthDef delay2
SynthDef("delay2", {
	arg bus = 0, buffer = 0, rate = 1, amp = 1, pan = -1, startPos = 0, gate = 1, tempo = 1, sample;
	var snd, effect;
	snd = PlayBuf.ar(
		numChannels: 2,
		bufnum: sample,
		rate: BufRateScale.kr(buffer) * rate,
		startPos: BufFrames.kr(buffer) * startPos,
		doneAction: 2;
	);
	snd = Pan2.ar(snd, pan);
	snd = snd+CombC.ar(snd, 1, tempo.reciprocal/1.5, 3);
	Out.ar(bus, snd*amp, effect);
}).add;
// end SynthDef delay2

// MIDI note assignments
MIDIdef.noteOn(\all, {arg vel, note;
	case

	// toggle between -1 and 1 for
	// turning delay1 and delay2 on/off
	// begin delay1 toggle
	{note == 11}
	{
		if
		(~delay1Toggle==(-1),
			{
				~delay1Toggle = (~delay1Toggle*(-1));
				"Delay 1 off".postln;
			}
		);
	}

	{note == 12}
	{
		if
		(~delay1Toggle!=(-1),
			{
				~delay1Toggle = (~delay1Toggle*(-1));
				"Delay 1 on".postln;
			}
		);
	}
	// end delay1 toggle

	// being delay2 toggle
	{note == 13}
	{
		if
		(~delay2Toggle==(-1),
			{
				~delay2Toggle = (~delay2Toggle*(-1));
				"Delay 2 off".postln;
			}
		);
	}

	{note == 14}
	{
		if
		(~delay2Toggle!=(-1),
			{
				~delay2Toggle = (~delay2Toggle*(-1));
				"Delay 2 on".postln;
			}
		);
	}
	// end delay2 toggle

	// increment or decrement tempo of delay1 and delay2
	{note == 20} {~tempo = ~tempo+0.1; "Tempo: ".postln; ~tempo.postln;}
	{note == 21} {~tempo = ~tempo-0.1; "Tempo: ".postln; ~tempo.postln;}
	// end tempo adjuster notes


	// bank functionality for loading new sounds
	// increment bank variable and calls load function load "l"
	{note == 22}
	{
		~bank = (~bank+1);
		l.(~bank);
		"Bank #".postln;
		~bank.postln;
	 }

	// decrement bank variable and call load function load "l"
	{note == 23}
	{
		~bank = (~bank-1);
		l.(~bank);
		"Bank #".postln;
		~bank.postln;
	}
	// end bank functionality

	// trigger loaded samples and react
	// according to state of delay on/off.
	// In this program, I have assigned notes 48-51
	// to play drum sounds with the hihat run through delay1.
	// The notes are currently ordered for a QuNeo controller
	{note == 48} {Synth("sample", [\sample, ~sample1]);}

	{note == 49} {Synth("sample", [\sample, ~sample2]);}

	{note == 50}
	{
		if(~delay1Toggle > (0),
			{
				Synth("sample", [\sample, ~sample3, \tempo, ~tempo]);
			},
			{
				Synth("delay1", [\sample, ~sample3, \tempo, ~tempo])
			}
		  );
	}

	{note == 51} {Synth("sample", [\sample, ~sample4]);}

	{note == 44}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample5]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample5]);
			}
		   );
	}

	{note == 45}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample6]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample6]);
			}
		   );
	}

	{note == 46}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample7]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample7]);
			}
		   );
	}

	{note == 47}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample8]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample8]);
			}
		   );
	}

	{note == 40}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample9]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample9]);
			}
		   );
	}

	{note == 41}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample10]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample10]);
			}
		   );
	}

	{note == 42}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample11]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample11]);
			}
		   );
	}

	{note == 43}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample12]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample12]);
			}
		   );
	}

	{note == 36}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample13]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample13]);
			}
		   );
	}

	{note == 37}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample14]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample14]);
			}
		   );
	}

	{note == 38}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample15]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample15]);
			}
		   );
	}

	{note == 39}
	{
		if (~delay2Toggle > (0),
			{
				Synth("sample", [\tempo, ~tempo, \sample, ~sample16]);

			},
			{
				Synth("delay2", [\tempo, ~tempo, \sample, ~sample16]);
			}
		   );
	}
   }
  ); // end MIDI note assignments
)
// end SuperCollider Music Controller Program