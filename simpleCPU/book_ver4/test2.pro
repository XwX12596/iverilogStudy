//-------------------------------test2.pro------------------------------------
@00 
101_11000        //  00   BEGIN:    LDA DATA_2	// Accum <-- [Data_2=1800h]=AA
0000_0001
011_11000        //  02             AND DATA_3  // Accum <-- Accum=AA & [Data_3=1802]=FF
0000_0010
100_11000        //  04             XOR DATA_2  // accum=00 = <--accum xor AA
0000_0001
001_00000        //  06             SKZ
0000_0000
000_00000        //  08	            HLT             //AND doesn't work
0000_0000
010_11000        //  0a             ADD DATA_1  //accum=1 <-- 0 +[1800]=1
0000_0000
001_00000        //  0c             SKZ
0000_0000
111_00000        //  0e             JMP ADD_OK  // pc <--- 12
0001_0010
000_00000        //  10             HLT             /ADD doesn't work
0000_0000
100_11000        //  12	    ADD_OK: XOR DATA_3 //acumm = FE <--- 1 xor FF
0000_0010
010_11000        //  14             ADD DATA_1      //FE plus 1 makes -1=FF
0000_0000
110_11000        //  16             STO TEMP    // [TEMP=1803]<----FF
0000_0011
101_11000        //  18             LDA DATA_1    // accum <-- 1
0000_0000
010_11000        //  1a             ADD TEMP        //-1 plus 1 should make zero
0000_0011
001_00000        //  1c             SKZ
0000_0000
000_00000        //  1e             HLT             //ADD Doesn't work
0000_0000
000_00000        //  20	    END:    HLT             //CONGRATULATIONS - TEST2 PASSED!
0000_0000
111_00000        //  22             JMP BEGIN       //run test again
0000_0000
//-----------------------------test2.pro--------------------------------------------