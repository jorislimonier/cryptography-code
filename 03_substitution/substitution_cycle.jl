sig = (("awkyoznetrf"), ("blgjsvxdqpchium"))
crypted_message = "wipmtgwvtbwuetqtcwpmtvtvrvuxurtcwvvtt"

function substit(orig_message, sig, decipher=false)
    """(de)ciphers orig_message with key sig"""
    transf_message = ""
    for orig_letter in orig_message
        for key in sig
            for key_i in 1:length(key)
                if key[key_i] == orig_letter
                    if key_i == 1 && decipher
                        substit_key_i = length(key)
                    elseif key_i == length(key) && !decipher
                        substit_key_i = 1
                    else
                        decipher ? substit_key_i = key_i - 1 : substit_key_i = key_i + 1
                    end
                    transf_message *= key[substit_key_i]
                end
            end
        end
    end
    return transf_message
end

substit(crypted_message, sig, true) # returns "ahquelasemainedepaquesestsivitepassee"