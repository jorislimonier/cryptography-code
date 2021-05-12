module Utils
using Primes

"""
computes the bezout coefficients of a and b
using the euclidian extended algorithm
"""
function get_bez_coef(input1, input2) # equivalent to gcdx(input1, input2)[2:3]
    gcd(input1, input2) != 1 && throw(ArgumentError("$input1 and $input2 must be coprimes"))

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
If modulus is prime, compute the inverse of some_int in Z/modulusZ
(using Fermat's little theorem), else throw an ArgumentError
"""
function get_inverse_fermat(some_int, modulus)
    !isprime(modulus) && throw(ArgumentError("$modulus is not prime, cannot apply Fermat's little theorem"))
    inv = some_int^(modulus - 2) % modulus
    println("inverse of $some_int in Z/$(modulus)Z is $inv")
    println("$some_int × $inv = $(some_int * inv) = $(some_int * inv % modulus) ∈ Z/$(modulus)Z")
    return inv
end

"""
If some_int and modulus are coprime, compute the inverse of some_int in Z/modulusZ
(using Euler's theorem), else throw an ArgumentError
"""
function get_inverse_euler(some_int, modulus) # equivalent to invmod(some_int, modulus)
    gcd(some_int, modulus) != 1 && throw(ArgumentError("$some_int and $modulus are not coprime, cannot apply Euler's theorem"))
    inv = some_int^(totient(modulus) - 1) % modulus
    println("inverse of $some_int in Z/$(modulus)Z is $inv")
    println("$some_int × $inv = $(some_int * inv) = $(some_int * inv % modulus) ∈ Z/$(modulus)Z")
    return inv
end


end


Utils.get_inverse_fermat(3, 3253)

moduli = [4, 7, 9, 11]
remainders = [3, 4, 1, 0]

temp1 = Utils.get_inverse_euler(moduli[2], moduli[1]) * remainders[1] * moduli[2] + Utils.get_inverse_fermat(moduli[1], moduli[2]) * remainders[2] * moduli[1]
Utils.get_inverse_euler(43, 735)

Utils.get_bez_coef(119, 11) == gcdx(119, 11)