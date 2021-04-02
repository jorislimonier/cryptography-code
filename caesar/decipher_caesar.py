c = "UNWWNVRANLDUNYNALNNRVVRWNWCNUDLRDB" # encrypted message


def decrypt(letter, key):
    uni = ord(letter)
    if uni - key < ord("A"):
        uni += 26
    uni -= key
    return chr(uni)

for key in range(26):
    p = ""
    for letter in c:
        p += decrypt(letter, key)
    
    print(f"{key}: {p}")