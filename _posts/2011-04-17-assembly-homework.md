---
title: Assembly Homework
layout: post
date: 2011-04-17 11:19:08
---
My Computer Systems course uses Bryant and O’Hallaron’s *Computer Systems: A Programmer’s Perspective*. The following is a fun homework assignment during our introduction to Assembly...

### Assembly
{% highlight c %}
int decode2(int x, int y, int z);
{% endhighlight %}

is compiled into IA32 assembly code. The body of the code is as follows:

{% highlight c %}
  x at %ebp+8, y at %ebp+12, z at %ebp+16

1    movl    12(%ebp), %edx
2    subl    16(%ebp), %edx
3    movl    %edx, %eax
4    sall    $31, %eax
5    sarl    $31, %eax
6    imull   8(%ebp), %edx
7    xorl    %edx, %eax
{% endhighlight %}

Parameters `x`, `y`, and `z` are stored at memory locations with offsets 8, 12, and 16 relative to the address in register `%ebp`. The code stores the return value in register `%eax`.

Write C code for `decode2` that will have an effect equivalent to our assembly code:

{% highlight c %}
int decode2(int x, int y, int z)
{
    int n = y - z;           // 1-2
    int m = (n << 31) >> 31; // 3-5
    return (n * x) ^ m;      // 6-7
}
{% endhighlight %}

#### Compile & Disassemble
Compiling the above code with `gcc -O1 -c decode2.c` and then running `objdump -d decode2.o` yields:

{% highlight c %}
decode2.o:	file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <decode2>:
    0:   29 d6			sub	%edx,%esi
    2:   89 f0			mov	%esi,%eax
    4:   c1 e0 1f		shl	$0x1f,%eax
    7:   c1 f8 1f		sar	$0x1f,%eax
    a:   0f af f7		imul	%edi,%esi
    d:   31 f0			xor	%esi,%eax
    f:   c3			retq
{% endhighlight %}

### More Assembly
For the following assembly, which has the exact same structure as exercise 3.54:
{% highlight c %}
1    movl    16(%ebp), %edx
2    movl    12(%ebp), %eax
3    addl    8(%ebp), %eax
4    addl    %eax, %eax
5    leal    (%edx,%edx,2), %edx
6    cmpl    %edx, %eax
7    setg    %al
8    movzbl  %al, %eax
{% endhighlight %}

The equivalent C code as a function, `foo`:
{% highlight c %}
int foo(int x, int y, int z)
{
    y += x + y;   // 2-4
    x *= 3;       // 5
    return y > x; // 6-8
}
{% endhighlight %}

####  Compile & Disassemble
Compiling the above code with `gcc -01 -c foo.c` on and then running `objdump -d foo.o` yields:
{% highlight c %}
foo.o:		file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <foo>:
    0:   8d 34 77		lea	(%rdi,%rsi,2),%esi
    3:   8d 3c 7f		lea	(%rdi,%rdi,2),%edi
    6:   39 fe			cmp	%edi,%esi
    8:   0f 9f c0		setg	%al
    b:   0f b6 c0		movzbl	%al,%eax
    e:   c3			retq
{% endhighlight %}
