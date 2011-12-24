" Vim syntax file
" Language:	Pandoc (superset of Markdown)
" Maintainer:	Jeremy Schultz <taozhyn@gmail.com> 
" URL:		
" Version:	2
" Changes:	2008-11-04	
"		-   Fixed an issue with Block elements (header) not being highlighted when 
"		    placed on the first or second line of the file
"		-   Fixed multi line HTML comment block
"		-   Fixed lowercase list items
"		-   Fixed list items gobbling to many empty lines
"		-   Added highlight support to identify newline (2 spaces)
"		-   Fixed HTML highlight, ignore if the first character in the
"		    angle brackets is not a letter 
"		-   Fixed Emphasis highlighting when it contained multiple
"		    spaces
" Remark:	Uses HTML and TeX syntax file

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn spell toplevel
syn case ignore
syn sync linebreaks=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set embedded HTML highlighting
syn include @HTML syntax/html.vim
syn match pdcHTML	/<\a[^>]\+>/	contains=@HTML

" Support HTML multi line comments
syn region pdcHTMLComment   start=/<!--/ end=/-->/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set embedded LaTex (pandox extension) highlighting
" Unset current_syntax so the 2nd include will work
unlet b:current_syntax
syn include @LATEX syntax/tex.vim

"   Single Tex command
syn match pdcLatex	/\\\w\+{[^}]\+}/	contains=@LATEX

"   Tex Block (begin-end)
syn region pdcLatex start=/\\begin{[^}]\+}\ze/ end=/\ze\\end{[^}]\+}/ contains=@LATEX 

"   Math Tex
syn match pdcLatex	/$[^$]\+\$/	   contains=@LATEX


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Block Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Needed by other elements 
syn match pdcBlankLine   /\(^\s*\n\|\%^\)/    nextgroup=pdcHeader,pdcCodeBlock,pdcListItem,pdcListItem1,pdcHRule,pdcTableHeader,pdcTableMultiStart,pdcBlockquote transparent


"""""""""""""""""""""""""""""""""""""""
" Title Block:
syn match pandocTitleBlock /\%^\(%.*\n\)\{1,3}$/ 


"""""""""""""""""""""""""""""""""""""""
" Headers:

"   Underlined, using == or --
syn match  pdcHeader    /^.\+\n[=-]\+$/ contains=@Spell nextgroup=pdcHeader contained skipnl

"   Atx-style, Hash marks
syn region pdcHeader    start="^\s*#\{1,6}[^#]*" end="\($\|#\+\)" contains=@Spell contained nextgroup=pdcHeader skipnl


"""""""""""""""""""""""""""""""""""""""
" Blockquotes:

syn match pdcBlockquote	    /\s*>.*$/  nextgroup=pdcBlockquote,pdcBlockquote2 contained skipnl 
syn match pdcBlockquote2    /[^>].*/  nextgroup=pdcBlockquote2 skipnl contained


"""""""""""""""""""""""""""""""""""""""
" Code Blocks:

"   Indent with at least 4 space or 1 tab
"   This rule must appear for pdcListItem, or highlighting gets messed up
syn match pdcCodeBlock   /\(\s\{4,}\|\t\{1,}\).*\n/ contained nextgroup=pdcCodeBlock  

"   HTML code blocks, pre and code
syn match pdcCodeStartPre	/<pre>/ nextgroup=pdcCodeHTMLPre skipnl transparent
syn match pdcCodeHTMLPre   /.*/  contained nextgroup=pdcCodeHTMLPre,pdcCodeEndPre skipnl
syn match pdcCodeEndPre  /\s*<\/pre>/ contained transparent

"   HTML code blocks, code
syn match pdcCodeStartCode	/<code>/ nextgroup=pdcCodeHTMLCode skipnl transparent
syn match pdcCodeHTMLCode   /.*/  contained nextgroup=pdcCodeHTMLCode,pdcCodeEndCode skipnl
syn match pdcCodeEndCode  /\s*<\/code>/ contained transparent


"""""""""""""""""""""""""""""""""""""""
" Lists:

"   These first two rules need to be first or the highlighting will be
"   incorrect

"   Continue a list on the next line
syn match pdcListCont /\s*[^-+*].*\n/ contained nextgroup=pdcListCont,pdcListItem,pdcListSkipNL transparent

"   Skip empty lines
syn match pdcListSkipNL /\s*\n/ contained nextgroup=pdcListItem,pdcListSkipNL 

"   Unorder list
syn match  pdcListItem /\s*[-*+]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl 

"   Order list, numeric
syn match  pdcListItem  /\s*(\?\(\d\+\|#\)[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, roman numerals (does not guarantee correct roman numerals)
syn match  pdcListItem  /\s*(\?[ivxlcdm]\+[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, lowercase letters
syn match  pdcListItem  /\s*(\?\l[\.)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, uppercase letters, does not include '.' 
syn match  pdcListItem  /\s*(\?\u[\)]\s\+/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl

"   Order list, uppercase letters, special case using '.' and two or more spaces
syn match  pdcListItem  /\s*\u\.\([ ]\{2,}\|\t\+\)/ contained nextgroup=pdcListSkipNL,pdcListCont skipnl


"""""""""""""""""""""""""""""""""""""""
" Horizontal Rules:

"   3 or more * on a line
syn match pdcHRule  /\s\{0,3}\(-\s*\)\{3,}\n/	contained nextgroup=pdcHRule

"   3 or more - on a line
syn match pdcHRule  /\s\{0,3}\(\*\s*\)\{3,}\n/	contained nextgroup=pdcHRule


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Span Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" Links:

"   Link Text 
syn match pdcLinkText /\[\zs[^\]]*\ze\]/ contains=@Spell

"   Link ID
syn match pdcLinkID /\][ ]\{0,1}\[\zs[^\]]*\ze\]/

"   Skip [ so we do not highlight it
syn match pdcSkip /^[ ]\{0,3}\[/ nextgroup=pdcLinkID 

"   Link ID - definition
syn match pdcLinkID /[^\]]*\ze\]:/ nextgroup=pdcSkip skipwhite contained

"   Skip ]: so we do not highlight it
syn match pdcSkip /\]:/ contained nextgroup=pdcLinkURL skipwhite

"   Link URL
syn region pdcLinkURL  start=/\](\zs/	end=/)/me=e-1 

"   Link URL on ID definition line
syn match pdcLinkURL /\s\+.*\s\+\ze[("']/ nextgroup=pdcLinkTitle skipwhite  contained
syn match pdcLinkURL /\s*.*\s*[^)"']\s*$/ contained 
syn match pdcLinkURL /\s*.*\s*[^)"']\s*\n\s*\ze[("']/ contained nextgroup=pdcLinkTitle skipwhite

"   Link URL for inline <> links
syn match pdcLinkURL /<http[^>]*>/
syn match pdcLinkURL /<[^>]*@[^>]*.[^>]*>/

" Link Title
syn match pdcLinkTitle /\s*[("'].*[)"']/ contained contains=@Spell


"""""""""""""""""""""""""""""""""""""""
" Emphasis:

"   Using underscores
syn match pdcEmphasis   / \(_\|__\)\([^_ ]\|[^_]\( [^_]\)\+\)\+\1/    contains=@Spell

"   Using Asterisks
syn match pdcEmphasis   / \(\*\|\*\*\)\([^\* ]\|[^\*]\( [^\*]\)\+\)\+\1/    contains=@Spell


"""""""""""""""""""""""""""""""""""""""
" Inline Code:
   
"   Using single back ticks
syn region pdcCode start=/`/		end=/`\|^\s*$/ 

"   Using double back ticks
syn region pdcCode start=/``[^`]*/      end=/``\|^\s*$/


"""""""""""""""""""""""""""""""""""""""
" Images:
"   Handled by link syntax


"""""""""""""""""""""""""""""""""""""""
" Misc:

"   Pandoc escapes all characters after a backslash
syn match NONE /\\\W/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Span Elements
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""
" Subscripts:
syn match pdcSubscript   /\~\([^\~\\ ]\|\(\\ \)\)\+\~/   contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Superscript:
syn match pdcSuperscript /\^\([^\^\\ ]\|\(\\ \)\)\+\^/   contains=@Spell

"""""""""""""""""""""""""""""""""""""""
" Strikeout:
syn match pdcStrikeout   /\~\~[^\~ ]\([^\~]\|\~ \)*\~\~/ contains=@Spell


"""""""""""""""""""""""""""""""""""""""
" Definitions:
syn match pdcDefinitions /:\(\t\|[ ]\{3,}\)/  nextgroup=pdcListItem,pdcCodeBlock,pdcBlockquote,pdcHRule

"""""""""""""""""""""""""""""""""""""""
" Footnote:
syn match pdcFootnoteID /\[\^[^\]]\+\]/ nextgroup=pdcFootnoteDef

"   This does not work correctly
syn region pdcFootnoteDef  start=/:/ end=/^\n\+\(\(\t\+\|[ ]\{4,}\)\S\)\@!/ contained contains=pdcFootnoteDef

"   Inline footnotes
syn region pdcFootnoteDef matchgroup=pdcFootnoteID start=/\^\[/ matchgroup=pdcFootnoteID end=/\]/


"""""""""""""""""""""""""""""""""""""""
" Tables:
"
"   Regular Table
syn match pdcTableHeader /\s*\w\+\(\s\+\w\+\)\+\s*\n\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableBody
syn match pdcTableBody	 /\s*\w\+\(\s\+\w\+\)\+\s*\n/ contained nextgroup=pdcTableBody,pdcTableCaption skipnl
syn match pdcTableCaption /\n\+\s*Table.*\n/ contained nextgroup=pdcTableCaptionCont 
syn match pdcTableCaptionCont /\s*\S.\+\n/ contained nextgroup=pdcTableCaptionCont 

"   Multi-line Table
syn match pdcTableMultiStart /^\s\{0,3}-\+\s*\n\ze\(\s*\w\+\(\s\+\w\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableMultiHeader
syn match pdcTableMultiEnd /^\s\{0,3}-\+/ contained nextgroup=pdcTableMultiCaption skipnl
syn match pdcTableMultiHeader /\(\s*\w\+\(\s\+\w\+\)\+\s*\n\)\+\s*-\+\(\s\+-\+\)\+\s*\n/ contained nextgroup=pdcTableMultiBody 
syn match pdcTableMultiBody /^\(\s\{3,}[^-]\|[^-\s]\).*$/ contained nextgroup=pdcTableMultiBody,pdcTableMultiSkipNL,pdcTableMultiEnd skipnl
syn match pdcTableMultiSkipNL /^\s*\n/ contained nextgroup=pdcTableMultiBody,pdcTableMultiEnd skipnl
syn match pdcTableMultiCaption /\n*\s*Table.*\n/ contained nextgroup=pdcTableCaptionCont 



"""""""""""""""""""""""""""""""""""""""
" Delimited Code Block: (added in 1.0)
syn region pdcCodeBlock matchgroup=pdcCodeStart start=/^\z(\~\{3,}\) \( {[^}]\+}\)\?/ matchgroup=pdcCodeEnd end=/^\z1\~*/ 


"""""""""""""""""""""""""""""""""""""""
" Newline, 2 spaces at the end of line means newline
syn match pdcNewLine /  $/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight groups
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi link pdcHeader		Title
hi link pdcBlockquote	    	Comment
hi link pdcBlockquote2	    	Comment

hi link pdcHTMLComment		Comment

hi link pdcHRule		Underlined
"hi link pdcHRule		Special

hi link pdcListItem		Operator
hi link pdcDefinitions		Operator

hi link pdcEmphasis		mailEmph
hi link pdcSubscript		Special
hi link pdcSuperscript		Special
hi link pdcStrikeout	 	Special

hi link pdcLinkText		Underlined
hi link pdcLinkID		Identifier
hi link pdcLinkURL		Type
hi link pdcLinkTitle		Comment

hi link pdcFootnoteID		Identifier
hi link pdcFootnoteDef		Comment
hi link pandocFootnoteCont 	Error

hi link pdcCodeBlock		String
hi link pdcCodeHTMLPre		String
hi link pdcCodeHTMLCode		String
hi link pdcCode			String
hi link pdcCodeStart		Comment
hi link pdcCodeEnd		Comment

hi link pandocTitleBlock	Comment

hi link pdcTableMultiStart	Comment
hi link pdcTableMultiEnd	Comment
hi link pdcTableHeader		Define
hi link pdcTableMultiHeader	Define
hi link pdcTableBody		Identifier
hi link pdcTableMultiBody	Identifier
hi link pdcTableCaption		Label
hi link pdcTableMultiCaption	Label
hi link pdcTableCaptionCont	Label

hi link pdcNewLine		Error


" For testing
hi link pdctest		Error


let b:current_syntax = "pandoc"

