using Primes
include("./utils/utils.jl")

function φ(modulus)
    return totient(modulus)
end

p = 29
q = 53
public_exp = 3 # e

modulus = p * q # n
private_exp = invmod(public_exp, φ(modulus))
public_key = (modulus, public_exp)
private_key = (modulus, private_exp)

message = 101 # m



function encrypt(message)
    return message^public_exp % modulus
end

c = encrypt(message)

function decrypt(c)
    return powermod(c, private_exp, modulus)
end
decrypt(c)


isprime(1456)
a = 241
b = 46

s0, t0 = Utils.bez_coef(a, b)
s0 * a + t0 * b