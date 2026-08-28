#include "user.h"
int main(int argc, char* argv[]){
	if(argc > 1){
		char** childArgs = malloc(sizeof(char*)*argc-1);
		for(int i = 1; i < argc; i++){
			childArgs[i-1] = argv[i];
		}

		uint64 start;
		asm volatile("rdtscp\n\t" : "=a"(start) : : "%rcx");
		int pid = fork();
		if(pid == 0){
			exec(argv[1], childArgs);
		}
		else{
			uint64 end;
			wait();
			asm volatile("rdtscp\n\t" : "=a"(end) : : "%rcx");
		       	printf(1, "%s took %d cycles to run.\n", argv[1], end-start);	
		}	
	}
	else{
		printf(1, "Please provide a program to time.\n");
	}
	exit();
}
