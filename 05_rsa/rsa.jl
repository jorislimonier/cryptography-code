using Primes

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

a = 240
b = 46
function eucl_ext_alg(a,b)
    r0 = a
    r1 = b
    s0 = 1
    s1 = 0
    t0 = 0
    t1 = 1

    while r1 != 0
        q = div(r0, r1)
        r0, r1 = r1, r0 - q * r1
        s0, s1 = s1, s0 - q * s1
        t0, t1 = t1, t0 - q * t1
    end

    # q, r0, r1, s0, s1, t0, t1
    return s0, t0
end
s0, t0 = eucl_ext_alg(a, b)
s0 * a + t0 * b