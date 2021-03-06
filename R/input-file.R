#' File Upload Control
#'
#' Create a file upload control that can be used to upload one or more files.
#'
#' Whenever a file upload completes, the corresponding input variable is set
#' to a dataframe. This dataframe contains one row for each selected file, and
#' the following columns:
#' \describe{
#'   \item{\code{name}}{The filename provided by the web browser. This is
#'   \strong{not} the path to read to get at the actual data that was uploaded
#'   (see
#'   \code{datapath} column).}
#'   \item{\code{size}}{The size of the uploaded data, in
#'   bytes.}
#'   \item{\code{type}}{The MIME type reported by the browser (for example,
#'   \code{text/plain}), or empty string if the browser didn't know.}
#'   \item{\code{datapath}}{The path to a temp file that contains the data that was
#'   uploaded. This file may be deleted if the user performs another upload
#'   operation.}
#' }
#'
#' @family input elements
#'
#' @inheritParams textInput
#' @param multiple Whether the user should be allowed to select and upload
#'   multiple files at once. \bold{Does not work on older browsers, including
#'   Internet Explorer 9 and earlier.}
#' @param accept A character vector of MIME types; gives the browser a hint of
#'   what kind of files the server is expecting.
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   sidebarLayout(
#'     sidebarPanel(
#'       fileInput("file1", "Choose CSV File",
#'         accept = c(
#'           "text/csv",
#'           "text/comma-separated-values,text/plain",
#'           ".csv")
#'         ),
#'       tags$hr(),
#'       checkboxInput("header", "Header", TRUE)
#'     ),
#'     mainPanel(
#'       tableOutput("contents")
#'     )
#'   )
#' )
#'
#' server <- function(input, output) {
#'   output$contents <- renderTable({
#'     # input$file1 will be NULL initially. After the user selects
#'     # and uploads a file, it will be a data frame with 'name',
#'     # 'size', 'type', and 'datapath' columns. The 'datapath'
#'     # column will contain the local filenames where the data can
#'     # be found.
#'     inFile <- input$file1
#'
#'     if (is.null(inFile))
#'       return(NULL)
#'
#'     read.csv(inFile$datapath, header = input$header)
#'   })
#' }
#'
#' shinyApp(ui, server)
#' }
#' @export
fileInput <- function(inputId, label, multiple = FALSE, accept = NULL,
  width = NULL) {

  inputTag <- tags$input(id = inputId, name = inputId, type = "file")
  if (multiple)
    inputTag$attribs$multiple <- "multiple"
  if (length(accept) > 0)
    inputTag$attribs$accept <- paste(accept, collapse=',')

  div(class = "form-group shiny-input-container",
    style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
    label %AND% tags$label(label),
    inputTag,
    tags$div(
      id=paste(inputId, "_progress", sep=""),
      class="progress progress-striped active shiny-file-input-progress",
      tags$div(class="progress-bar")
    )
  )
}
