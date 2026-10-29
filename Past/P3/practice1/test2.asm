ori $t1, $0, 123
ori $t2, $0, 325

j test

sub $t3, $t2, $t1

test:

add $t3, $t2, $t1