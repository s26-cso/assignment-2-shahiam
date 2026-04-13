/*#include <stdio.h>
#include <stdlib.h>

int main() {
    // Open the file in read mode
    FILE* fp = fopen("input.txt", "r");
    if (fp == NULL) {
        return 0;
    }

    // Determine the length of the string (n)
    fseek(fp, 0, SEEK_END);
    long n = ftell(fp);
    
    // Palindrome check logic
    long left = 0;
    long right = n - 1;
    int is_palindrome = 1;

    while (left < right) {
        char c1, c2;

        // Read character from the left
        fseek(fp, left, SEEK_SET);
        c1 = fgetc(fp);

        // Read character from the right
        fseek(fp, right, SEEK_SET);
        c2 = fgetc(fp);

        if (c1 != c2) {
            is_palindrome = 0;
            break;
        }
        left++;
        right--;
    }

    if (is_palindrome) printf("Yes\n");
    else printf("No\n");

    fclose(fp);
    return 0;
}*/

.data
filename: .asciz "input.txt"
mode: .asciz "r"
msg_yes: .asciz "Yes\n"
msg_no: .asciz "No\n"

.text
.globl main

main:
    addi sp,sp,-64
    sd ra,56(sp)
    sd s0,48(sp)    #s0:file pointer
    sd s1,40(sp)    #s1:length
    sd s2,32(sp)    #s2:left pointer
    sd s3,24(sp)    #s3:right pointer
    sd s4,16(sp)    #s4:c1
    sd s5,8(sp)     #s5:c2

    la a0,filename
    la a1,mode
    call fopen
    add s0,a0,x0
    beq s0,x0,exit   

    add a0,s0,x0
    add a1,x0,x0
    addi a2,x0,2    #SEEK_END=2
    call fseek

    add a0,s0,x0
    call ftell
    add s1,a0,x0    #s1=len

    add s2,x0,x0
    addi s3,s1,-1

loop:
    bge s2,s3,printyes

    add a0,s0,x0
    add a1,s2,x0    #offset=left
    addi a2,x0,0  #SEEK_SET=0
    call fseek
    add a0,s0,x0
    call fgetc
    add s4,a0,x0    #s4=c1

    add a0,s0,x0
    add a1,s3,x0    #offset=right
    addi a2,x0,0  #SEEK_SET=0
    call fseek
    add a0,s0,x0
    call fgetc
    add s5,a0,x0    #s5=c2

    bne s4,s5,printno

    addi s2,s2,1
    addi s3,s3,-1
    jal x0,loop

printyes:
    la a0,msg_yes
    call printf
    jal x0,cleanup

printno:
    la a0,msg_no
    call printf

cleanup:
    addi a0,s0,0
    call fclose

exit:
    add a0,x0,x0
    ld ra,56(sp)
    ld s0,48(sp)
    ld s1,40(sp)
    ld s2,32(sp)
    ld s3,24(sp)
    ld s4,16(sp)
    ld s5,8(sp)
    addi sp,sp,64
    jalr x0,0(ra)
