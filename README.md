# Cryptography code

Coding / decoding of several ciphers ( details below).

## Table of contents

- [Codes implemented](#odes-implemented)
  - [Folder structure](#folder-structure)
- [TODO](#todo)
- [Log](#log)
- [Contributions](#contributions)
  - [Future contributions](#future-contributions)
  - [Past contributions](#past-contributions)
- [Get in touch](#get-in-touch)

## Codes implemented

|                 | Julia | Python | R                                                      |
| --------------- | ----- | ------ | ------------------------------------------------------ |
| Caesar cipher   | Yes   | Yes    | No                                                     |
| Vigenère cipher | Yes   | Yes    | Yes [(link)](https://plaaschou.shinyapps.io/Decypher/) |
| Substitution    | Yes   | No     | No                                                     |
| Permutation     | Yes   | No     | No                                                     |
| RSA             | Yes   | No     | No                                                     |

### Folder structure

```
|
├── Caesar
|   └── Caesar Python
├── Vigenère
|   ├── Vigenère Python
|   └── Vigenère R
├── Substitution
|   └── Substition Julia
├── Permutation
|   └── Permutation Julia
└── RSA
    └── RSA Julia (under construction)
```

## TODO

- **Python**
  - Finish Vigenère
    1. Use most likely keys lengths to get key
    2. **Frequency analysis:** Compare frequency of letters with english and french (switching from french to english should simply be a change of parameter :arrow_right: use dataframe `df_freq_letter`)
  - Class-ify the code because it's cooler
  - Add documentation in readme to explain the train of thought for each file
- **R**
  - Add documentation

## Contributions

### Future contributions

All contributions are welcome. The code can very much be improved, be it corrections, comments, code cleaning...etc.

If you are familiar with other programming languages, you are very welcome to send me your implemention of the concepts seen in class and I will post them in this repo.

### Past contributions

Thank you to Sébastien PLAASCH (sebastien.plaasch.001@student.uni.lu) for providing the R code, as well as making the app [accessible online via browser](https://plaaschou.shinyapps.io/Decypher/). Sébastien specifically provided heavy comments in the code in order to make it understandable to newcomers. He also described the decipher-helper process in the mobile

## Get in touch

For any question/remark, please feel free to email me at joris.limonier.001@student.uni.lu .

## Log

#### 27/04/21:

- Renamed substitution Julia
- Added variants of substitution Julia
- Permutation (Julia)

#### 16/04/21:

- Substitution (Julia)

#### Prior to 16/04/21:

- Caesar cipher (Python & R)
- Vigenère cipher (Python)
