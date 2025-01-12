# app.R
library(shiny)
library(readxl)
library(stringr)

ui <- fluidPage(
  titlePanel("Shiny Quiz (T/F, Single, Multiple)"),
  
  # Display the current question
  uiOutput("question_ui"),
  
  # Immediate feedback
  textOutput("immediate_feedback"),
  
  # Buttons
  fluidRow(
    column(3, actionButton("submit_btn", "Submit Answer")),
    column(3, actionButton("next_btn", "Next Question"))
  ),
  
  hr(),
  h4("Final Score"),
  textOutput("final_score")
)

server <- function(input, output, session) {
  # 1. Read in the question data from Excel
  quizData <- read_excel("questions.xlsx")
  
  # 2. Keep track of the current question index
  current_q <- reactiveVal(1)
  
  # 3. Keep track of correctness for each question
  #    NA if not answered yet, TRUE if correct, FALSE if wrong
  rv <- reactiveValues(
    correctness = rep(NA, nrow(quizData))
  )
  
  # 4. Render the UI for the current question
  output$question_ui <- renderUI({
    q_idx <- current_q()
    
    # If we've exceeded the number of questions, just say "done"
    if (q_idx > nrow(quizData)) {
      return(p("All questions answered."))
    }
    
    # Grab the row data for the current question
    q_row   <- quizData[q_idx, ]
    q_type  <- q_row$Type
    q_text  <- q_row$Question
    # Choices (if any) are stored as a semicolon‐separated string
    # We convert them into a character vector
    choices <- str_split(q_row$Choices, ";")[[1]]
    
    # Build a UI panel with the question text + the appropriate input widget
    wellPanel(
      p(strong(paste("Question", q_idx, ":", q_text))),
      
      # We'll use different input widgets based on question type
      if (q_type == "tf") {
        # True/False question
        # We'll present two radio options: "True" and "False"
        radioButtons(
          "user_answer",
          label   = "Select True or False:",
          choices = c("True", "False"),
          selected = character(0)
        )
      } else if (q_type == "single") {
        # Single‐choice question
        radioButtons(
          "user_answer",
          label   = "Select one:",
          choices = choices,
          selected = character(0)
        )
      } else if (q_type == "multiple") {
        # Multiple‐choice question
        checkboxGroupInput(
          "user_answer",
          label   = "Select all that apply:",
          choices = choices,
          selected = character(0)
        )
      } else {
        # Fallback if an unknown type is encountered
        p("Unknown question type: ", q_type)
      }
    )
  })
  
  # 5. Check the user's answer on "Submit Answer"
  observeEvent(input$submit_btn, {
    q_idx <- current_q()
    # Do nothing if beyond last question
    if (q_idx > nrow(quizData)) return()
    
    # Extract needed data
    q_row           <- quizData[q_idx, ]
    q_type          <- q_row$Type
    correct_answers <- q_row$CorrectAnswers
    feedback_text   <- q_row$Feedback
    
    # The correct answers might be semicolon‐separated for multiple
    correct_vec <- str_split(correct_answers, ";")[[1]] |> trimws()
    
    # The user's answer might be a character scalar or a vector
    user_answer <- input$user_answer
    
    if (q_type == "tf" || q_type == "single") {
      # We expect user_answer to be a single string
      # Compare to the correct answer
      is_correct <- identical(user_answer, correct_vec[1])
      
    } else if (q_type == "multiple") {
      # The user_answer might be character(0) if none selected
      # We compare sets ignoring order
      user_vec <- sort(user_answer)
      corr_vec <- sort(correct_vec)
      is_correct <- identical(user_vec, corr_vec)
    } else {
      is_correct <- FALSE  # If unknown type, fail safe
    }
    
    # Store correctness
    rv$correctness[q_idx] <- is_correct
    
    # Show immediate feedback
    if (is_correct) {
      output$immediate_feedback <- renderText(
        paste("Correct!", feedback_text)
      )
    } else {
      # For multiple answers, show all correct
      # For tf/single, correct_vec has only 1
      output$immediate_feedback <- renderText({
        paste0(
          "Incorrect. Correct answer(s): ",
          paste(correct_vec, collapse = ", "),
          "\n",
          feedback_text
        )
      })
    }
  })
  
  # 6. Move to the next question
  observeEvent(input$next_btn, {
    if (current_q() <= nrow(quizData)) {
      current_q(current_q() + 1)
      # Clear immediate feedback
      output$immediate_feedback <- renderText("")
    }
    
    # If we've gone past the last question, calculate final score
    if (current_q() > nrow(quizData)) {
      total_correct <- sum(rv$correctness, na.rm = TRUE)
      total_questions <- nrow(quizData)
      output$final_score <- renderText({
        paste0(
          "You got ", total_correct, " out of ",
          total_questions, " correct."
        )
      })
    }
  })
}

shinyApp(ui = ui, server = server)
