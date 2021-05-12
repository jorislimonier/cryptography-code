p = 101
a = 13
g = 2
b = 18

B = g ^ b % p
A = g ^ a % p
shared_common_key = (g^a % p) ^ b % p

x = 5
y = x * shared_common_key % p
