module Utils
using Primes

"""
computes the bezout coefficients of a and b
using the euclidian extended algorithm
"""
function get_bez_coef(input1, input2)
    rest = [input1 input2]
    bez_coef = [[1, 0] [0, 1]]

    while rest[2] != 0
        q = div(rest[1], rest[2])
        rest = [rest[2], rest[1] - q * rest[2]]
        bez_coef = [[bez_coef[2, 1], bez_coef[1, 1] - q * bez_coef[2, 1]] [bez_coef[2, 2], bez_coef[1, 2] - q * bez_coef[2, 2]]]
    end
    return bez_coef[1, 1], bez_coef[1, 2]
end

"""
If p is prime, compute it's inverse,
else throw and ArgumentError
"""
function get_inverse(some_int, modulus)
    !isprime(modulus) && throw(ArgumentError("$modulus is not prime, cannot apply Fermat's little theorem"))
    inv = some_int^(modulus - 2) % modulus
    println("inverse of $some_int in Z/$(modulus)Z is $inv")
    println("$some_int × $inv = $(some_int * inv % modulus) ∈ Z/$(modulus)Z")
    return inv
end
end


Utils.get_bez_coef(240, 46)
Utils.get_inverse(3, 29)