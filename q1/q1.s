/*#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

struct Node* make_node(int val) {
    if (newNode == NULL) return NULL;
    newNode->val = val;
    newNode->left = NULL;
    newNode->right = NULL;
    return newNode;
}

struct Node* insert(struct Node* root, int val) {
    if (root == NULL) {
        return make_node(val);
    }
    if (val < root->val) {
        root->left = insert(root->left, val);
    } else if (val > root->val) {
        root->right = insert(root->right, val);
    }
    return root;
}

struct Node* get(struct Node* root, int val) {
    if (root == NULL || root->val == val) {
        return root;
    }
    if (val < root->val) {
        return get(root->left, val);
    }
    return get(root->right, val);
}

int getAtMost(int val, struct Node* root) {
    int best = -1;
    struct Node* curr = root;
    while (curr != NULL) {
        if (curr->val == val) {
            return val;
        } else if (curr->val < val) {
            best = curr->val;
            curr = curr->right;
        } else {
            curr = curr->left;
        }
    }
    return best;
}*/

.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
    addi sp,sp,-16
    sd ra,8(sp)
    sd s0,0(sp)

    add s0,a0,x0    #a0 contains val
    addi a0,x0,24   #passing size to malloc,pointer to newNode = a0
    jal ra, malloc

    sw s0,0(a0)        # newNode->val = val
    sd x0,8(a0)        # newNode->left = NULL
    sd x0,16(a0)       # newNode->right = NULL

    ld ra,8(sp)
    ld s0,0(sp)
    addi sp,sp,16

    jalr x0,0(ra)


insert:
    beq a0,x0,noroot    #a0=root

    lw t0,0(a0)
    beq a1,t0,exitinsert  #if val equal then exit
    blt a1,t0,leftinsert

    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)

    add s0,a0,x0    #s0 = current root
    add s1,a1,x0    #s1 = val
    ld a0,16(s0)    #curr-->right
    add a1,s1,x0    #a1 has val
    jal ra,insert
    sd a0,16(s0)     #attached made node
    add a0,s0,x0

    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    jalr x0,0(ra)

leftinsert:
    addi sp,sp,-32
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)

    add s0,a0,x0    #s0 = current root
    add s1,a1,x0    #s1 = val
    ld a0, 8(s0)    #curr-->left
    add a1,s1,x0    #a1 has val
    jal ra,insert
    sd a0,8(s0)     #attached made node
    add a0,s0,x0

    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    jalr x0,0(ra)

noroot:
    add a0,a1,x0
    jal x0,make_node

exitinsert:
    jalr x0,0(ra)


get:
    beq a0,x0,exitget

    lw t0,0(a0) #t0 has val
    beq t0,a1,exitget  #curr-->val == val
    blt a1,t0,getleft

    ld a0,16(a0)
    jal x0,get

getleft:
    ld a0,8(a0)
    jal x0,get

exitget:
    jalr x0,0(ra)


getAtMost:
    addi t0,x0,-1

loop:
    beq a1,x0,exitgetAM
    lw t1,0(a1)
    beq t1,a0,found
    blt t1,a0,getAMsmol #(current smaller than val)

    ld a1,8(a1)
    jal x0,loop

getAMsmol:
    add t0,t1,x0
    ld a1,16(a1)
    jal x0,loop

found:
    jalr x0,0(ra)

exitgetAM:
    add a0,t0,x0
    jalr x0,0(ra)
