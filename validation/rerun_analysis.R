# Render the revised R workflow and save aggregate metrics.
arguments <- commandArgs(trailingOnly = FALSE)
script_file <- sub("^--file=", "", arguments[grepl("^--file=", arguments)][1])
root <- normalizePath(file.path(dirname(script_file), ".."))
setwd(root)
source_file <- "Notebooks/loan_default_decision_tree.Rmd"
e <- new.env(parent = globalenv())
output <- rmarkdown::render(source_file, output_file = "executed_workflow.html",
    output_dir = file.path(root, "Reports"), envir = e, quiet = TRUE)
result <- list(training_rows=nrow(e$train),test_rows=nrow(e$test),resampled_training_rows=nrow(e$resampled),pruned_terminal_nodes=sum(e$pruned$frame$var=="<leaf>"),test_metrics=as.list(e$metrics(e$test$isLoanDefault,e$predicted)),all_nondefault_metrics=as.list(e$metrics(e$test$isLoanDefault,rep("0",nrow(e$test)))))
packages <- c("knitr","rmarkdown","jsonlite","dplyr","ggplot2","forecast","vars","rpart","ggfortify","broom","nycflights13","rpart.plot")
versions <- setNames(lapply(packages,function(p) if(requireNamespace(p,quietly=TRUE)) as.character(packageVersion(p)) else NA_character_),packages)
result$checked_at_utc <- format(Sys.time(), tz="UTC", usetz=TRUE)
result$R_version <- R.version.string
result$package_versions <- versions
result$source <- source_file
result$scope <- "Revised R Markdown workflow executed and rendered; archived historical analyses are not claimed as reproduced when preprocessing or evaluation changed."
jsonlite::write_json(result, "Reports/validation_results.json", pretty=TRUE, auto_unbox=TRUE, na="null", digits=12)
writeLines(capture.output(sessionInfo()), "Reports/validated_session.txt")
cat(jsonlite::toJSON(result,pretty=TRUE,auto_unbox=TRUE,na="null",digits=12),"\n")
