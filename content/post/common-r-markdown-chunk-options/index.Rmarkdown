---
title: Commonly used R markdown chunk options
author: ''
date: '2020-09-15'
slug: commonly-used-r-markdown-chunk-options
categories: []
tags: []
subtitle: ''
summary: 'There are more than 50 chunk options that can be used to fine tune the behavior of `knitr` when processing code chunks, in this lesson we are going to list all the chunk options and discuss some of the most commonly used.'
authors: []
lastmod: '2020-09-15T18:55:16+01:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: true
projects: []
---

Let us first understand what a code chunk is and when it can be used;  

A code chunk is an environment where codes can be written to produce an output or just to display codes in a rmarkdown document. Code chunks are used when there is a need to render code output into documents.  

There are more than 50 chunk options that can be used to fine tune the behavior of `knitr` when processing code chunks, in this lesson we are going to list all the chunk options and discuss some of the most commonly used.

Chunk options are written in chunk headers. 

{{< figure library="true" src="rmarkdown/chunk-sample.png" alt="r markdown chunk options sample fig">}}


above is an example of a R markdown chunk options. 

Chunk options can be written on individual code chunks, it can also be written globally on the whole document, so you do not have to repeat the options in every single code chunk. 
To set chunk options globally, call `knitr::opts_chunk$set()` in a code chunk (usually the first one in the document). see example below  

{{< figure library="true" src="rmarkdown/chunk-global.png" alt="r markdown chunk options global fig">}}


## R markdown chunk options best practices  

1. Avoid spaces, periods (.), and underscores (_) in chunk labels and paths. If you need separators, you are recommended to use hyphens (-) instead.  
  * A chunk label is the name given to a particular code chunk.  

2. The chunk header must be written on one line. You must not break the line  

3. All option values must be valid R expressions. You may think of them as values to be passed to function arguments.  
  + For example, options that take character values must be quoted, e.g., results = 'asis' and out.width = '\\textwidth' (remember that a literal backslash needs double backslashes).  
  
## R markdown chunk options list 
The list is documented in the format “option: Use. (default value; type of value)“.  

| **Plots**  | **Text output**     |  **Cache**  |  **Code decoration** | **Animation** | **Others**  |
|---------   | ---------           |---------    |--------              |   --------    |---------    |
|- **fig.path**: A prefix to be used to generate figure file paths. *("figure"; character)*|- **echo**: Whether to display the source code in the output document (TRUE; logical or numeric)|- **cache**: Whether to cache a code chunk *(FALSE; logical)*|- **tidy**: Whether to reformat the R code *(FALSE)*. Possible values[TRUE,styler]|**animation.hook**: A hook function to create animations in HTML output; the default hook uses FFmpeg to convert images to a WebM video. *(knitr::hook_ffmpeg_html; function or character)*|- **R.options**: Local R options for a code chunk *(NULL; list)*|        
|- **fig.keep**: How plots in chunks should be kept *("high"; character)*. Possible values[high,none,all,first,last]|- **results**: Controls how to display the text results *("markup"; character)*. Possible values[markup,asis,hold,hide]     |- **cache.path**: A prefix to be used to generate the paths of cache files. For R Markdown, the default value is based on the input filename *("cache/"character)*   |- **tidy.opts**: A list of options to be passed to the function determined by the tidy option *(NULL; list)*         |**interval**: Time interval (number of seconds) between animation frames. *(1; numeric)*        |- **code**: If provided, it will override the code in the current chunk. This allows us to programmatically insert code into the current chunk. *(NULL; character)*  |
|- **fig.show**: How to show/arrange the plots *("asis"; character)*. Possible values[asis,hold,animate,hide]|- **collapse**: Whether to, if possible, collapse all the source and output blocks from one code chunk into a single block (by default, they are written to separate blocks). *(FALSE; logical)*       |- **cache.vars**: A vector of variable names to be saved in the cache database. *(NULL; character)*   |- **prompt**: Whether to add the prompt characters in the R code. *(FALSE; logical)*         |**ffmpeg.bitrate**: To be passed to the -b:v argument of FFmpeg to control the quality of WebM videos.*(1M; character)* |- **ref.label**: A character vector of labels of the chunks from which the code of the current chunk is inherited *(NULL; character)*            |
|- **dev**: The graphical device to generate plot files *("pdf"; character)*     |- **warning**: Whether to preserve warnings (produced by warning()) in the output. *(TRUE; logical)*. If FALSE, all warnings will be printed in the console instead of the output document.      |- **cache.globals**: A vector of the names of variables that are not created from the current chunk. *(NULL; character)*|- **comment**: The prefix to be added before each line of the text output. *('##'; character)*|**ffmpeg.format**: The video format of FFmpeg, i.e., the filename extension of the video. *(webm; character)*  |- **child**: A character vector of paths of child documents to be knitted and input into the main document. *(NULL;character)*|
|- **dev.args**: More arguments to be passed to the device. *(NULL; list)*    |- **error**: Whether to preserve errors (from stop()) *(TRUE; logical)*          |- **cache.lazy**: Whether to lazyLoad() or directly load() objects. *(TRUE; logical)*     |- **highlight**: Whether to syntax highlight the source code. *(TRUE; logical)*      |         NA             |- **engine**: The language name of the code chunk. *("R"; character)*. Possible values[R,python,sql,bash,c,julia]
|- **fig.ext**: File extension of the figure output *(NULL; character)* |- **message**: Whether to preserve messages emitted by message() (similar to the option warning). *(TRUE; logical)*       |**cache.comments**: *(NULL; logical)*  If FALSE, changing comments in R code chunks will not invalidate the cache database. |**class.source**: Class names for source code blocks in the output document. *(NULL; character)* |         NA             |- **engine.path**:The path to the executable of the engine *(NULL; character)*
|- **dpi**: The DPI (dots per inch) for bitmap devices (dpi * inches = pixels). *(72; numeric)*     |- **include**:  Whether to include the chunk output in the output document. *(TRUE; logical)*         |- **cache.rebuild**: *(FALSE; logical)*  If TRUE, reevaluate the chunk even if the cache does not need to be invalidated.  |- **attr.source**: Attributes for source code blocks. *(NULL; character)*  |         NA             |- **opts.label**: The label of options set in knitr::opts_template. *(NULL; character)*
|- **fig.width**: Width of the plot (in inches), to be used in the graphics device. *(7; numeric)*  |- **strip.white**: Whether to remove blank lines in the beginning or end of a source code block in the output. *(TRUE; logical)*   |- **dependson**: A character vector of chunk labels to specify which other chunks this chunk depends on. *(character or numeric)*|- **size**: Font size of the chunk output from .Rnw documents. *("normalize"; character)*  |         NA             |- **purl**: When running knitr::purl() to extract source code from a source document, whether to include or exclude a certain code chunk. *(TRUE; logical)*
|- **fig.height**: Height of the plot (in inches), to be used in the graphics device. *(7; numeric)* |- **class.output**: A vector of class names to be added to the text output blocks. This option only works for HTML output formats in R Markdown. *(NULL; character)*|**autodep**: Whether to analyze dependencies among chunks automatically by detecting global variables in the code (may not be reliable) *(FALSE; logical)*        |**background**: Background color of the chunk output of .Rnw documents. *("#F7F7F7"; character)*   |         NA             |-      NA    | 
|- **fig.asp**: The aspect ratio of the plot, i.e., the ratio of height/width *(NULL; numeric)*   |- **class.message**: Similar to class.output, but applied to messages *(NULL; character)*|          NA            |- **indent**: A string to be added to each line of the chunk output. *(character)*       |         NA             |-      NA    |
|- **fig.dim**: A numeric vector of length 2 to provide fig.width and fig.height *(NULL; numeric)*    |- **class.warning**: Similar to class.output, but applied to warnings *(NULL; character)*|-        NA            |-          NA            |         NA             |-      NA    |
|- **out.width**: Width of the plot in the output document, which can be different with its physical fig.width *(NULL; character)*|- **class.error**: Similar to class.output, but applied to errors *(NULL; character)*|-          NA            |-          NA            |         NA             |-      NA    |
|- **out.height**: Height of the plot in the output document, which can be different with its physical fig.height *(NULL; character)*|- **attr.output**: *(character)*|-         NA            |-          NA            |         NA             |-      NA    |
|- **out.extra**: Extra options for figures *(NULL; character)*|- **attr.message**: *(NULL; character)*|-         NA            |-          NA            |         NA             |-      NA    |
|- **fig.retina**: *(1; numeric)*|- **attr.warning**: *(NULL; character)*|-         NA            |-          NA            |         NA             |-      NA    |
|- **resize.width**: The width to be used in \resizebox{}{} in LaTeX output *(NULL; character)*|- **attr.error**: *(NULL; character)*|-        NA            |-          NA            |         NA             |-      NA    |
|- **resize.height**: The height to be used in \resizebox{}{} in LaTeX output *(NULL; character)*|- **split**: Whether to split the output into separate files and include them in LaTeX by \input{} or HTML by <iframe /iframe>. *(FALSE; logical)*     |-         NA            |-          NA            |         NA             |-      NA    |
|- **fig.align**: Alignment of figures in the output document. *("default"; character)*. Possible values[default,left,right,center]|-         NA            |-         NA            |-          NA            |         NA             |-      NA    |
|- **fig.link**: A link to be added onto the figure. *(NULL; character)*|-         NA            |-          NA            |-          NA            |         NA             |-      NA    |
|- **fig.env**: The LaTeX environment for figures *("figure"; character)* |-         NA            |-          NA            |-          NA            |         NA             |-      NA    |
|- **fig.cap**: A figure caption. *(NULL; character)* |-         NA            |-          NA            |-          NA            |         NA             |-      NA    |
|- **fig.scap**:  A short caption. This option is only meaningful to LaTeX output. *(NULL; character)*|-         NA            |-          NA            |-          NA            |         NA             |-      NA    |
|- **fig.lp**:A label prefix for the figure label to be inserted in \label{}. *("fig";character)*  |-         NA            |-          NA            |-          NA            |         NA             |-      NA   |
|- **fig.pos**:  A character string for the figure position arrangement to be used in \begin{figure}[]. *(" ";character)* |-         NA            |-          NA           |-          NA            |         NA             |-      NA    |
|- **fig.subcap**: Captions for subfigures *(NULL)*   |-         NA            |-          NA            |-          NA            |         NA             |-      NA    | 
|- **fig.ncol**: The number of columns of subfigures *(NULL; integer)*  |-         NA            |-          NA            |-          NA            |         NA             |-      NA    |
|- **fig.sep**: A character vector of separators to be inserted among subfigures. *(NULL; character)* |-         NA            |-         NA            |-          NA            |         NA             |-      NA    |
|- **fig.process**: A function to post-process figure files. *(NULL; function)*|-       NA            |-          NA            |-         NA            |         NA             |-      NA    |
|- **fig.showtext**: *(NULL; logical)*  If TRUE, call showtext::showtext_begin() before drawing plots.|-       NA            |-          NA            |-          NA            |         NA             |-      NA    |
|- **external**: Whether to externalize tikz graphics (pre-compile tikz graphics to PDF). *(TRUE; logical)*    |-       NA           |-          NA            |-          NA            |         NA             |-      NA    |
|- **sanitize**: Whether to sanitize tikz graphics (escape special LaTeX characters). *(FALSE; character)*  |-       NA            |-          NA            |-          NA            |         NA             |-      NA    |  


## Commonly used R markdown chunk options  
These are some of the most commonly used r markdown chunk options  

* **include**  
  + There are times when you will only want to present your work to people and not have them struggle to understand the codes behind each output in the document you presented to them. The `include` chunk option enables us to control visibility of code chunks.
* **echo**  
  + Sometimes we may also not want to display the output of a code chunk, the `echo` option gives us the ability to control the visibility of the output of code chunks.
* **warning**  
  + This option is very helpful when you are preparing a document and the codes you are running prints a lot of warning messages out in the document, the warning messages can be hidden by simple changing the warning option to **TRUE** (default is **FALSE**)
* **message**  
  + The `message` option is similar to the `warning` option, it can be used to hide messages that are not warning messages from printing out in the document. e.g messages that displays when loading a package.
* **error**  
  + There are also times we may want to hide error messages if any. The `error` option enables us to be able to control display of error messages. 
* **fig.width**  
  + Sometimes we may want our plots to have a much wider or lesser width in a document, the `fig.width` makes it possible to define specific width for plots in a document.
* **fig.height**  
  + Similar to `fig.width`, the `fig.height` option makes it possible to define specific height for plots in a document.
* **fig.dim**  
  + The `fig.dim` option is an alternative approach for defining values for both `fig.width` and `fig.height` of a plot in a document.














