MidiOut mout;
MidiOut moutBeatstep;

if (!mout.open(2)) {
  <<<"Couldn't open ultralite port">>>;
  me.exit();
};

if (!moutBeatstep.open(0)) {
  <<<"Couldn't open beatstep port">>>;
  me.exit();
};

[0, 2, 3, 7, 10] @=> int scale[];

50 => int root;
2 => int octavesUp;
0 => int octavesDown;


Math.random2(5, 12) => int length;
int sequence[length];
dur durations[length];

for(0 => int i; i < length; i++) {
  scale[Math.random2(0, scale.size() - 1)] => sequence[i];
  Math.random2(500, 2000)::ms => durations[i];
}

0 => int counter;

while(1) {
  for( 0 => int i; i < 1; i ++ ) {
    spork ~ send(sequence[shiftedCounter(i)] + root + randomOctaveOffset(), durations[shiftedCounter(i)], 0);
  }
  send(sequence[counter] + root + randomOctaveOffset() - 36, durations[counter], 1);
  (counter + 1) % length => counter;
}

fun void tune() {
  spork ~ send(80, 1000::ms, 0);
  send(80 - 36, 1000::ms, 1);
}

fun int shiftedCounter(int i) {
  return (( counter + length ) - i) % length;
}

fun int randomOctaveOffset() {
  return (Math.random2(octavesDown, octavesUp) * 12);
}

fun void send(int n, dur l, int port) {
  MidiMsg msg;
  
  Math.random2(10, 400)::ms => now;
  0x90 => msg.data1;
  n => msg.data2;
  127 => msg.data3;

  if ( port == 0 ) {
    mout.send(msg);
  } else {
    moutBeatstep.send(msg);
  }

  l / 2 => now;
  
  0x80 => msg.data1;
  n => msg.data2; 
  0 => msg.data3;

  if ( port == 0 ) {
    mout.send(msg);
  } else {
    moutBeatstep.send(msg);
  }
}
