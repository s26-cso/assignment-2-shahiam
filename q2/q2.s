/*#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
    if (argc <= 1) return 0;

    int n = argc - 1;
    // Allocate memory for IQ array, result indices, and the stack
    int* iqs = (int*)malloc(n * sizeof(int));
    int* result = (int*)malloc(n * sizeof(int));
    int* stack = (int*)malloc(n * sizeof(int));
    int top = -1; // Stack pointer

    // Parse input and initialize results
    for (int i = 0; i < n; i++) {
        iqs[i] = atoi(argv[i + 1]);
        result[i] = -1;
    }

    // Next Greater Element logic (Iterating right to left)
    for (int i = n - 1; i >= 0; i--) {
        // Pop elements from stack that are smaller than or equal to current IQ
        while (top >= 0 && iqs[stack[top]] <= iqs[i]) {
            top--;
        }
        
        // If stack is not empty, the top element is the NGE's index
        if (top >= 0) {
            result[i] = stack[top];
        }
        
        // Push current index onto the stack
        stack[++top] = i;
    }

    // Print results
    for (int i = 0; i < n; i++) {
        printf("%d%c", result[i], (i == n - 1) ? '\n' : ' ');
    }

    // Cleanup
    free(iqs);
    free(result);
    free(stack);
    return 0;
}*/

 .data
 fmt_spaceint: .asciz "%d "
 fmt_newlineint: .asciz "%d\n"

 .text
 .globl main

 main:
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp)    #s0=n
    sd s1,40(sp)    #s1=adress of iqs array
    sd s2,32(sp)    #s2=address of result array
    sd s3,24(sp)    #s3=adress of stack
    sd s4,16(sp)    #s4=stacktop
    sd s5,8(sp)     #s5=iterator
    sd s6,0(sp)     #s6=adress to argv

    addi t0,x0,1
    ble a0,t0,notenoughargs #args<=1
    addi s0,a0,-1
    addi s6,a1,0

    slli a0,s0,2    #n*4
    call malloc   #iqs array
    add s1,a0,x0

    slli a0,s0,2    #n*4
    call malloc   #results array
    add s2,a0,x0

    slli a0,s0,2    #n*4
    call malloc   #stack
    add s3,a0,x0

    add s5,x0,x0    #iterator=0


inputloop:
    bge s5,s0,logicinit

    addi t0,s5,1
    slli t0,t0,3    #8 byte pointers
    add t0,s6,t0    #t0 pointer to argv
    ld a0,0(t0)
    call atoi     #calling atoi to convert argv to ints 

    slli t1,s5,2    #n*4 for iqs
    add t2,s1,t1    #iqs[i]
    sw a0,0(t2)     #store converted int into iqs array

    add t2,s2,t1    #adress to result[i]
    addi t3,x0,-1
    sw t3,0(t2)     #initializing result[i]=-1

    addi s5,s5,1
    jal x0,inputloop


logicinit:
    addi s4,x0,-1   #top=-1
    addi s5,s0,-1   #i=n-1

nextgreaterequalogic:
    blt s5,x0,print

popala:
    blt s4,x0,popdone

    slli t0,s4,2
    add t0,s3,t0
    lw t1,0(t0)     #t1=index at stack top(curr student IQ)

    slli t1,t1,2
    add t1,s1,t1    #t1=adress of iqs[stack[top]]
    lw t2,0(t1)     #IQ value at stack top

    slli t3,s5,2
    add t3,s1,t3
    lw t4,0(t3)            #t4=Current student's IQ

    bgt t2,t4,popdone
    addi s4,s4,-1
    jal x0,popala

popdone:
    blt s4,x0,push  #stack empty

    slli t0,s4,2
    add t0,s3,t0
    lw t1,0(t0)     #index of next greatest

    slli t2,s5,2
    add t2,s2,t2
    sw t1,0(t2)     #Store index in result[i]

push:
    addi s4,s4,1
    slli t0,s4,2
    add t0,s3,t0
    sw s5,0(t0)     #push current index onto stack

    addi s5,s5,-1
    jal x0,nextgreaterequalogic

print:
    addi s5,x0,0
printloop:
    bge s5,s0,cleanup

    slli t0,s5,2
    add t0,s2,t0
    lw a1,0(t0)
    addi t1,s0,-1
    beq s5,t1,printnewline

    la a0,fmt_spaceint
    call printf
    jal x0,printnext

printnewline:
    la a0,fmt_newlineint
    call printf

printnext:
    addi s5,s5,1
    jal x0,printloop

cleanup:
    addi a0,s1,0
    call free
    addi a0,s2,0
    call free
    addi a0,s3,0
    call free

notenoughargs:
    addi a0, x0, 0          #return 0
    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    ld s5,8(sp)
    ld s6,0(sp)
    addi sp,sp,64
    jalr x0,0(ra)
