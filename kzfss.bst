%% File: `kzfss.bst'
%% A modification of `plainnat.bst' for use with natbib package by:
%%
%% Wolfgang Plaschg
%% E-mail: wpl@gmx.net
%%
%% The original 'plainnat.bst' belongs to:
%%
%% Copyright 1993-2005 Patrick W Daly
%% Max-Planck-Institut f\"ur Sonnensystemforschung
%% Max-Planck-Str. 2
%% D-37191 Katlenburg-Lindau
%% Germany
%% E-mail: daly@mps.mpg.de
%%
%% This program can be redistributed and/or modified under the terms
%% of the LaTeX Project Public License Distributed from CTAN
%% archives in directory macros/latex/base/lppl.txt; either
%% version 1 of the License, or any later version.
%%
ENTRY
  { address
    author
    booktitle
    booktitleaddon
    chapter
    edition
    editor
    howpublished
    institution
    isbn
    issn
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    titleaddition
    titleaddon
    type
    url
    urldate
    volume
    year
  }
  {}
  { label extra.label sort.label short.list }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {add.colon}
{ duplicate$ empty$
    { 'skip$ }
    { duplicate$ #-1 #1 substring$
      duplicate$ "." = swap$
      duplicate$ ":" = swap$
      duplicate$ "!" = swap$
      "?" =
      or
      or
      or 
        { skip$ }
        { ":" * }
      if$
    }
  if$
}

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$
          write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.nonnull.colon}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.colon write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.colon " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.colon}
{ duplicate$ empty$
    'pop$
    'output.nonnull.colon
  if$
}

FUNCTION {output.space}
{ duplicate$ empty$
    'pop$
    { 's := " " * write$ s }
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.check.colon}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull.colon
  if$
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\emph{" swap$ * "}" * }
  if$
}

FUNCTION {emph.name}
{ duplicate$ empty$
    { pop$ "" }
    { "\name{" swap$ * "}" * }
  if$
}

FUNCTION {quotify}
{ duplicate$ empty$
    { pop$ "" }
    { ">>" swap$ * "<<" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 =
        { s nameptr "{vv~}{ll}" format.name$ emphasize
          s nameptr "{, ff}{, jj}" format.name$ emphasize * 't :=
        }
        { s nameptr "{ff }" format.name$ emphasize
          s nameptr "{vv~}{ll}" format.name$ emphasize *
          s nameptr "{, jj}" format.name$ emphasize * 't :=
        }
      if$
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 =
                { "," * }
                'skip$
              if$
              %ACHTUNG! others wurde oben emphasiziert
              t "\emph{others}" =
                { " et~al." * }
                { " und " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.incoll.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff }" format.name$ emphasize
      s nameptr "{vv~}{ll}" format.name$ emphasize *
      s nameptr "{, jj}" format.name$ emphasize * 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            %ACHTUNG! others wurde oben emphasiziert
            { t "\emph{others}" =
                { " et~al." * }
                { " und " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {format.authors}
{ author empty$
    { "o.~A." }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { " (Hg.)" * }
        { " (Hg.)" * }
      if$
    }
  if$
}

FUNCTION {format.incoll.editors}
{ editor empty$
    { "" }
    { editor format.incoll.names
      editor num.names$ #1 >
        { " (Hg.)" * }
        { " (Hg.)" * }
      if$
    }
  if$
}

FUNCTION {format.isbn}
{ isbn empty$
    { "" }
    { new.block "ISBN " isbn * }
  if$
}

FUNCTION {format.issn}
{ issn empty$
    { "" }
    { new.block "ISSN " issn * }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { new.block url 
      urldate empty$
        'skip$
        { ", " urldate * * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title missing$
	{ "o.~T." }
	{ title }
  if$    
  titleaddon missing$
    { skip$ }
    { add.period$ " " * titleaddon * }
  if$    
}

FUNCTION {format.full.names}
{'s :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{vv~}{ll}" format.name$ 't :=
      nameptr #1 >
        {
          namesleft #1 >
            { ", " * t * }
            {
              numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " und " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {author.editor.full}
{ author empty$
    { editor empty$
        { "" }
        { editor format.full.names }
      if$
    }
    { author format.full.names }
  if$
}

FUNCTION {author.full}
{ author empty$
    { "" }
    { author format.full.names }
  if$
}

FUNCTION {editor.full}
{ editor empty$
    { "" }
    { editor format.full.names }
  if$
}

FUNCTION {make.full.names}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.full
    { type$ "proceedings" =
        'editor.full
        'author.full
      if$
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\pagebreak[0]\bibitem[" write$
  %%"\bibitem[" write$
  label write$
  ")" make.full.names duplicate$ short.list =
     { pop$ }
     { * }
   if$
  "]{" * write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year duplicate$ empty$
    { "empty year in " cite$ * warning$
       pop$ "o.\,J." }
    'skip$
  if$
  month empty$
    'skip$
    { month 
      " " * swap$ *
    }
  if$
  extra.label *
}

FUNCTION {format.year}
{ year empty$
    { "empty year in " cite$ * warning$
      "o.\,J." }
    { year } 
  if$
  extra.label *
}

FUNCTION {format.btitle}
{ booktitle missing$
    { titleaddon missing$
        { title }
        { title add.period$ " " * titleaddon * }
      if$
    }
    { booktitleaddon missing$
        { booktitle }
        { booktitle add.period$ " " * booktitleaddon * }
      if$
    }
  if$    
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.series.volume}
{ series empty$
    { volume empty$
        { "" }
        { "Bd." volume tie.or.space.connect }
      if$
    }
    { volume empty$
        { series }
        { series add.period$ "Bd." volume tie.or.space.connect tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "Bd." volume tie.or.space.connect }
  if$
}

FUNCTION {format.series}
{ series empty$
    { "" }
    { series }
  if$
}

FUNCTION {format.number}
{ number empty$
    { "" }
    { "Nr." number tie.or.space.connect }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition "~" * "Aufl." * }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "S." pages n.dashify tie.or.space.connect }
        { "S." pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { " (" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ": " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.vol.num}
{ volume field.or.null
  number empty$
    'skip$
    { "\penalty0 (" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "Kap." }
        { type }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "in: " format.btitle * }
        { "in: " format.incoll.editors * ", " * format.btitle * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technischer Bericht" }
    'type
  if$
  number empty$
    { skip$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "In \emph{" journal * "}" * }
      if$
    }
    { "In " key * }
  if$
  " \citep{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "in: "
    }
    { "Bd." volume tie.or.space.connect
      " aus " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { "\emph{" * series * "}" * }
          if$
        }
        { key * }
      if$
    }
    'skip$
  if$
  ", \citet{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "in: \emph{" booktitle * "}" * }
          if$
        }
        { "in: " key * }
      if$
    }
    { "in: " }
  if$
  " \citet{" * crossref * "}" *
}

FUNCTION {format.publisher}
{
  address missing$
    {  publisher missing$
         { organization missing$
             { "" }
             { "o.\,O." }
           if$
         }
         { "o.\,O." }
       if$
    }
    { address }
  if$
  publisher missing$
    { organization missing$
        'skip$
        { ": " * organization * }
      if$
    }
    { ": " * publisher * }
  if$
}

FUNCTION {format.school}
{
  address missing$
    { school missing$
        { "" }
        { school }
      if$
    }
    { school missing$
        { address }
        { address ": " * school * }
      if$
    }
  if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year "year" output.check
  new.block
  format.title "title" output.check.colon
  new.block
  crossref missing$
    { journal format.vol.num.pages tie.or.space.connect output }
    { format.article.crossref output.nonnull
      format.pages output
      if$
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.year "year" output.check
  new.block
  format.btitle "title" output.check.colon
  new.block
  titleaddition output
  new.block
%
% keine Ahnung wozu dieses book.crossref gut sein soll
%  crossref missing$
%    { 
      format.series.volume output
      format.number output
      new.block
%      format.edition output
      format.publisher "publisher" output.check
%    }
%    { new.block
%      format.book.crossref output.nonnull
%    }
%  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  author format.key output
  format.year output
  new.block
  format.title "title" output.check.colon
  howpublished address new.block.checkb
  howpublished output
  address output
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.year "year" output.check
  new.block
  format.btitle "title" output.check.colon
%  crossref missing$
%    { 
      new.block
      format.series.volume output
      format.number output
      format.chapter.pages "chapter and pages" output.check
      new.sentence
%      format.edition output
      new.block
      format.publisher "publisher" output.check
%    }
%    { format.chapter.pages "chapter and pages" output.check
%      new.block
%      format.book.crossref output.nonnull
%    }
%  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year "year" output.check
  new.block
  format.title "title" output.check.colon
  new.block
  format.chapter.pages output
  format.in.ed.booktitle output.space
  new.block
  format.series.volume output
  format.number output
  new.sentence
%  format.edition output
  format.publisher "publisher" output.check
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year "year" output.check
  new.block
  format.title "title" output.check.colon
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.series.volume output
      format.number output
      format.pages output
      new.sentence
      format.publisher output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  format.authors output
  author format.key output
  format.year output
  new.block
  format.btitle "title" output.check.colon
  organization address new.block.checkb
  organization output
  address output
%  format.edition output
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year "year" output.check
  new.block
  format.title "title" output.check.colon
  new.block
  "Diplomarbeit" format.thesis.type output
  format.school output
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  author format.key output
  format.year output
  new.block
  format.title output.colon
  new.block
  howpublished output
  format.publisher output
  new.block
  format.url
  output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year "year" output.check
  new.block
  format.btitle "title" output.check.colon
  new.block
  "Dissertation" format.thesis.type output.nonnull
  format.school output
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  format.editors output
  editor format.key output
  format.year "year" output.check
  new.block
  format.btitle "title" output.check.colon
  format.series.volume output
  format.number output
  new.sentence
  format.publisher output
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year "year" output.check
  new.block
  format.title "title" output.check.colon
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  format.year output
  new.block
  format.title "title" output.check.colon
  new.block
  format.url output
  new.block
  note "note" output.check
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"Jän."}

MACRO {feb} {"Feb."}

MACRO {mar} {"März"}

MACRO {apr} {"Apr."}

MACRO {may} {"Mai"}

MACRO {jun} {"Jun."}

MACRO {jul} {"Jul."}

MACRO {aug} {"Aug."}

MACRO {sep} {"Sep."}

MACRO {oct} {"Okt."}

MACRO {nov} {"Nov."}

MACRO {dec} {"Dez."}

MACRO {first} {"1."}

MACRO {second} {"2."}

MACRO {third} {"3."}

MACRO {fourth} {"4."}

MACRO {fifth} {"5."}

MACRO {sixth} {"6."}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.lab.names}
{ 's := 
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " und " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
        { editor format.lab.names }
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  "("
  *
  year duplicate$ empty$
  short.list key field.or.null = or
     { pop$ "" }
     'skip$
  if$
  *
  'label :=
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    {
      s nameptr "{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr #1 >
        {
          "   "  *
          namesleft #1 = t "others" = and
            { "zzzzz" * }
            { numnames #2 > nameptr #2 = and
                { "zz" * year field.or.null * "   " * }
                'skip$
              if$
              t sortify *
            }
          if$
        }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}


FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  "    "
  *
  cite$
  *
  #1 entry.max$ substring$
  'sort.label :=
  sort.label *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.label next.extra }

INTEGERS { longest.label.width last.extra.num last.extra.num.dummy number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num "a" chr.to.int$ #25 + >
      { last.extra.num 'last.extra.num.dummy :=
        last.extra.num.dummy "a" chr.to.int$ - 'last.extra.num.dummy :=
        last.extra.num.dummy #26 - 'last.extra.num.dummy :=
%        last.extra.num.dummy warning$
        "z" last.extra.num.dummy int.to.str$ * 'extra.label :=
%        extra.label warning$
      }
      { last.extra.num int.to.chr$ 'extra.label :=
      }
      if$
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
  label extra.label * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT

FUNCTION {begin.bib}
{   preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  %% "\begin{literaturliste}"
  "\begin{thebibliography}{" number.label int.to.str$ * "}" *
  write$ newline$
  "\providecommand{\natexlab}[1]{#1}"
  write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
  %% "\end{literaturliste}" write$ newline$  
}

EXECUTE {end.bib}
