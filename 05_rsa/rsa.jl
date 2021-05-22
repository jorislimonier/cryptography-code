using Primes

function φ(modulus)
    return totient(modulus)
end

p = 10243
q = 35897
public_exp = 9007 # e

modulus = p * q # n
private_exp = invmod(public_exp, φ(modulus))
public_key = (modulus, public_exp)
private_key = (modulus, private_exp)

MESSAGE = 37120 # m

function encrypt(message)
    return powermod(message, public_exp,  modulus)
end

encrypted_message = encrypt(MESSAGE)

function decrypt(encrypted_message)
    return powermod(encrypted_message, private_exp, modulus)
end
decrypt(encrypted_message)
