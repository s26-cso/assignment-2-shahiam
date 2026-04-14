#include<stdio.h>
#include<stdlib.h>
#include<dlfcn.h>

int main(){
    char op[10];
    int a,b;
    char libname[20];

    while(1){
        int eof = scanf("%s %d %d",op,&a,&b);

        if(eof == EOF){
            break;
        }
        
        sprintf(libname,"./lib%s.so",op);

        void*openlib = dlopen(libname,RTLD_LAZY);
        if(!openlib){
            continue;
        }

        int (*pointtoop)(int,int);
        pointtoop = (int(*)(int,int))dlsym(openlib,op);
        if(pointtoop){
            int result = pointtoop(a,b);
            printf("%d\n",result);
        }
        dlclose(openlib);
    }

    return 0;
}