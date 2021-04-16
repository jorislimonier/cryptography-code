module vig_decipher

function shift_letter(letter, key)
    """shifts letter from key positions
    -> give a positive key to cipher
    -> give a negative key to decipher"""
    letter = uppercase(letter) # convert letter to uppercase
    old_letter_int = Int(only(letter))
    if old_letter_int + key < 65 # order of letter 'a'
        new_letter_int = old_letter_int + key + 26
    elseif old_letter_int + key > 90 # order of letter 'z'
        new_letter_int = old_letter_int + key - 26
    else
        new_letter_int = old_letter_int + key
    end
    return string(Char(new_letter_int))
end

function shift_message(message, key, decipher=false)
    """shifts message from keykeykey...etc
    according to the Vigenere Cipher
    set decipher to true in order to decipher (otherwise cipher)"""
    message = replace(message, " "=>"") # remove blanks spaces
    message = uppercase(message)
    new_message = ""
    # decipher letters from the message and add to new_message
    for message_index in 0:length(message)-1
        key_index = (message_index % length(key)) +1
        message_letter = message[message_index+1]
        key_letter = key[key_index]
        ord_key_letter = Int(only(key_letter)) - Int('A')
        # For decipher mode, change sign of ord_key_letter
        ord_key_letter = decipher ? -ord_key_letter : ord_key_letter
        deciphered_letter = shift_letter(message_letter, ord_key_letter) 
        new_message *= deciphered_letter # append to already (de-)ciphered message
    end
    return new_message
end
end # end of module


using .vig_decipher

TWO_A = "la rencontre a lieu ce matin" 
TWO_B = "DIDOLYMBVETDOSFROMEXF"

vig_decipher.shift_message(TWO_A, "ESCH", false) # returns PSTLRUQUXJGHPAGBGWOHXAP
vig_decipher.shift_message(TWO_B, "BELVAUX", true) # returns CESTLEPARTYDUVENDREDI