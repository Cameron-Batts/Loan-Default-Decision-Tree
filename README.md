# Loan Default Classification with Cost-Sensitive Trees

**Author:** Cameron Batts

## Problem
Examine class imbalance, classification-tree pruning and explicit false-negative cost assumptions.

## Approach
Split by class before preprocessing, learn median fills on training rows, resample only training observations to a 2:1 nondefault/default ratio, explicitly fit a classification tree and prune at a fixed cp=0.002. Evaluate class-1 recall against an all-nondefault baseline.

## Reported results
The bundled dataset has 29,092 records, including 3,227 defaults (11.09%). The archived analysis illustrates a root-only initial tree and later tree structures, but reports no held-out classification metrics. Improved default detection has not been established.

## Limitations and corrections
Historical resampling used the full dataset after creating a split, and later rpart fits omitted method="class" while the response was numeric. This revision fixes both issues. Pruning uses the original fixed cp rather than claiming CV selection. Resampling changes prevalence and the 10:1 loss is illustrative. Training imputation precedes internal rpart CV, so its scores are not fully fold-isolated; final assessment uses the untouched test split.

## Verification
Dataset dimensions, missingness and relevant counts were checked directly. R is unavailable in this environment, so revised R code was reviewed but not parsed, executed or rendered. No new fitted-model performance is claimed.

## Data
The included data have no documented upstream source or redistribution license in the original repository. Preserve provenance when it becomes available.

## Run
Install R and Pandoc (or use RStudio), then run from the repository root:
```r
source("install.R")
rmarkdown::render("Notebooks/loan_default_decision_tree.Rmd")
```
Dependencies are unpinned.

## Files
- [R Markdown analysis](Notebooks/loan_default_decision_tree.Rmd)
- [Readable report](Reports/loan_default_decision_tree.html)
- [Original PDF](Reports/Loan%20Default%20Prediction%20via%20Decision%20Trees.pdf) — historical export; conclusions may predate the corrections above.
- [Live portfolio report](https://cameron-batts.github.io/loan_default_decision_tree.html)
