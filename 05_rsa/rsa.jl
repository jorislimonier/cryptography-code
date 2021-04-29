using Primes
include("./utils/utils.jl")

p = 29
q = 53
modulus = p * q

public_exp = 3
private_exp = 971
public_key = (1537, 3)
private_key = (modulus, private_exp)

phi = (p - 1) * (q - 1)

message = 101

function encrypt()
    return message^public_exp % modulus
end

c = encrypt()

function decrypt()
    return (c^private_exp) % modulus
end

decrypt()

a = 241
b = 46

s0, t0 = Utils.eucl_ext_alg(a, b)
s0 * a + t0 * b