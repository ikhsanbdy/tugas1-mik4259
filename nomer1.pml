#define N	3	/*Number of Proc*/

short flags[N]={0};
int nCrit = 0;

active [N] proctype p(){
	do
		::true->
			l1:	skip;
			l2:	flags[_pid] = 1;
			l3:	do
					::true -> 
						atomic{
							int i;
							bool stop = 1;
							for(i : 0 .. N-1){
								if
									::(flags[i] < 3) -> skip
									::else -> 
										stop = 0;
										break;
								fi;
							}
							if
								::stop -> break;
								::else -> skip;
							fi;
						}
				od;
			l4:	flags[_pid] = 3;
			bool checkL5 = 0;
			atomic{
				int i;
				for(i : 0 .. N-1){
					if
						::(flags[i] == 1) -> 
							checkL5 = 1;
							break;
						::else -> skip
					fi;
				}
			};
			l5:	if
					::checkL5 ->
						l6:	flags[_pid] = 2;
						l7:	do
								::true ->
									atomic{
										int i;
										bool stop = 0;
										for(i : 0 .. N-1){
											if
												::(flags[i] == 4) -> 
													stop = 1;
													break;
												::else -> skip
											fi;
										}
										if
											::stop -> break;
											::else -> skip;
										fi;
									}
							od;
					::else -> skip
				fi;
			l8:	flags[_pid] = 4;
			l9:	do
					::true ->
						atomic{
							int i;
							bool stop = 1;
							for(i : 0 .. _pid-1){
								if
									::(flags[i] < 2) -> skip
									::else ->
										stop = 0;
										break
								fi
							}
							if
								::stop -> break;
								::else -> skip;
							fi
						}
				od;
			/*BEGINING OF CRITICAL SECTION*/
			l10: nCrit++; assert(nCrit == 1); nCrit--;
			/*END OF CRITICAL SECTION*/
			l11:	do
						::true ->
							atomic{
								int i;
								bool stop = 1;
								for(i : _pid+1 .. N-1){
									if
										::((flags[i] == 0) || (flags[i] == 1) || (flags[i] == 4)) -> skip
										::else ->
											stop = 0;
											break
									fi;
								}
								if
									::stop -> break;
									::else -> skip;
								fi;
							}
					od
			l12: flags[_pid] = 0;
	od
}