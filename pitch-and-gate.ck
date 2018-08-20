Step gate => dac.chan(2);
Step pitch => dac.chan(3);

0.2118 => float VOLT;
VOLT / 12 => float STEP;

now + 3::second => time later;

0 => gate.next;
0 => int counter;

while(true) {
  1.0 => gate.next;
  Math.random2f(-0.5, 0.5)=> pitch.next;
  1::ms => now;
  0 => gate.next;
  Math.random2(50, 1000)::ms => now;
}

<<<"end">>>;
