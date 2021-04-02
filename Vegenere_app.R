library(shiny)
library(ggplot2)
library(tibble)
library(dplyr)
library(magrittr) #this is a very useful library that allows piping : e.g A %>% B takes the output of A and apply function defined in B 
library(shinyWidgets)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Decypher"),
    
    #Input for the application
    sidebarLayout(
        #Textbox for the code
        sidebarPanel(
            textInput("code", "Code to decypher",
                      value = "XCXWGHHWNSEMGBYIPI",
                      width = '800px', placeholder = "Hello"),
            # actionButton("Code", "Code"),
        
        #Slider for the key length
        sliderInput("keylength",
                        "Key length",
                        min = 0,
                        max = 32,
                        value = 0),
        
        #Slider to select characters in position k + Z*keylength
        sliderInput("Charnum",
                        "Searching for key's k-th character",
                        min = 1,
                        max = 32,
                        value = 1),

        #Slider for k-th letter of the key
        sliderTextInput("KeyLet",
                        "Possible k-th letter of the key",
                        LETTERS),

        #Textbox for to enter the key
        textInput("key","Enter key here",value="CODE")
        ),
        
        # Output of the program (see server for more details)
        mainPanel(
            p("The goal is to find the best approximation of the red curve (frequency of letters in english) by the blue curve (frequency of the letters in relevent substring of cyphertext: characters in position k + Zm where m is the length of the key)."),
            p("First, find the correct key length"),
            p("To find the k-th character of the key, set the second slider to k, then shift the third slider (possible letter) until you believe you have a match, then write down the letter in the key textbox"),
            plotOutput("distPlot"), #Return the barplot
            htmlOutput("decoded")   #Return the decyphered text
        )
    )
)

# Server manages the logic for the 
server <- function(input, output) {
    
    #distPlot is the bar plot
    output$distPlot <- renderPlot({
        
        #Generate a data frame with the frequency of the letters in english
        FREQ = tibble(let = LETTERS, 
                      freq = c(0.0815,0.0097,0.0315,0.0373,0.1739,0.0112,0.0097,0.0085,0.0731,0.0045,0.0002,
                               0.0569,0.0287,0.0712,0.0528,0.0280,0.0121,0.0664,0.0814,0.0722,0.0638,0.0164,
                               0.0003,0.0041,0.0028,0.0015),
                      r = rank(-freq,ties.method = "min")) #Adding rank in decreasing order
        
        chars = strsplit(input$code,'') %>% unlist() #convert text into vector of characters
        z = nchar(input$code) #saves length of cyphertext
        keylen = as.integer(input$keylength) #Saves length of the key
        LETNUM = match(input$KeyLet,LETTERS)-1 #converts the selected letter in slider into a number (A=0,B=1,etc)
        #Define a function that will take a characters vectors as an input and outputs a dataframe with frequency of letters
        FreqTable <- function(vector) {
            vector %>% 
                table %>% #Table does most of the job here, but output is not necessarilly nice to use 
                as_tibble() %>% #converting into tibble (lazy data.frame) for ease of manipulation
                set_colnames(c("let","count")) %>% #rename the headers of the data frame
                mutate(freq = count/sum(count), #mutate adds some columns, here the column 'freq' to return frequency
                    r = rank(-freq,ties.method = "max")) #also add the rank of the letters.
        }
        coincidence <- function(n){
          sapply(n:z,FUN=function(k) (chars[k] == chars[k-n])) %>% unlist() %>% sum
        }
        
        FindKeyLength <- data.frame(x=1:32,c=sapply(1:32,coincidence)) %>% 
          ggplot() + 
          geom_col(aes(x,c)) + 
          labs(x="Possible key length",y="Number of coincidences") + 
          theme_minimal()
        
        #Define a function that will take a characters vectors and return a plot.
        dec <- function(n,k){
            s = FreqTable(chars[seq(input$Charnum,z,k)])                # seq(a,b,c) returns a sequence (a,a+c,a+2c,... ) until b
                                                                        # here I am just filtering the letters of the cyphertext
                                                                        # and apply the FreqTable function on it.
            B = s %>% mutate(acnum = match(let,LETTERS),                # adding few columns: acnum = number associated with letter
                             num = mod(match(let,LETTERS)-n-1,26)+1,    # Shift number by n, modulo 26
                             newlet = LETTERS[num])                     # Return the shifted letter
            
            # ggplot is used to make plots. The first one I commented out returns the plot based on frequency, the second one returns plot based on rank (E which is the most used letter will be associated with 27-1 = 26, A (second most used letter) will be associated to 27-2 = 25, etc. until 1)

            # ggplot() +
            #     geom_bar(data = FREQ, aes(let,freq/max(freq)), fill="red",alpha = .5, stat="identity") +
            #     geom_bar(data = B, aes(newlet,freq/max(freq)),alpha=.5, fill="blue",stat="identity") +
            #     labs(x="letter",y="frequency")+
            #     theme_minimal()
            ggplot() +
                geom_bar(data = FREQ, aes(let,27-r), fill="red",alpha = .5, stat="identity") + #plot based on FREQ (english frequency)
                geom_bar(data = B, aes(newlet,27-r),alpha=.5, fill="blue",stat="identity") + #plot based on filtered cyphertext
                labs(x="letter",y="frequency")+ #rename the labels of the plot
                theme_minimal() #theme minimal just makes the background white.
        }
        if(input$keylength == 0){FindKeyLength} else {dec(LETNUM,keylen)} # Call the function defined up there: LETNUM is the letter selected in the slider.
    })

    #Now, also generate an output for the decyphered text.
    output$decoded <- renderText({
        chars = input$code %>% strsplit('') %>% unlist() #Once again transfort text into a character vector
        m = length(chars)   #length of the text
        keylength = input$keylength 
        key = input$key %>% strsplit('') %>% unlist()
        typedkey = length(input$key) #Will use the code in the last textbox 
        decoded <- chars #store a copy of the cyphertext (I will decode here.)
        
        # Now I implement a loop: each occurence it takes the the k-th chars and shift them with the associated letter of the key
        # For example, if the keylength is CODES (length = 5):
        # In the first occurence it will take the chars 1,1+5,1+2*5,etc. and shift them by C = 2
        # In the second occurence, it will take the chars 2, 2+5, 2+2*5, etc. and shift them by O = 17?
        for (i in 1:nchar(input$key)){
            REF = decoded[seq(i,m,input$keylength)]
            decoded[seq(i,m,input$keylength)] <- LETTERS[mod(match(REF ,LETTERS) - match(key[i],LETTERS),26)+1]
        }
        if(input$keylength==TRUE){"Hello"} else {decoded}#return the decoded text
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
