#!/usr/bin/python

## To access this file as plain text please go to
## http://freewisdom.org/projects/python-markdown/odt2txt_py.raw_content
## After downloading save with ".py" extension
## this isn't world editable, is it?
"""
ODT2TXT
=======

ODT2TXT convers files in Open Document Text format (ODT) into
Markdown-formatted plain text.

Writteby by [Yuri Takhteyev](http://www.freewisdom.org).

*Modified* for this project

Project website: http://www.freewisdom.org/projects/python-markdown/odt2txt
Contact: yuri [at] freewisdom.org

License: GPL 2 (http://www.gnu.org/copyleft/gpl.html) or BSD

Version: 0.1 (April 7, 2006)
"""


import sys, os, zipfile, xml.dom.minidom, shutil, re

IGNORED_TAGS = ["office:annotation"]

FOOTNOTE_STYLES = ["Footnote"]


class TextProps :
    """ Holds properties for a text style. """

    def __init__ (self):
        
        self.italic = False
        self.bold = False
        self.fixed = False

    def setItalic (self, value) :
        if value == "italic" :
            self.italic = True

    def setBold (self, value) :
        if value == "bold" :
            self.bold = True

    def setFixed (self, value) :
        self.fixed = value

    def __str__ (self) :

        return "[i=%s, h=i%s, fixed=%s]" % (str(self.italic),
                                          str(self.bold),
                                          str(self.fixed))

class ParagraphProps :
    """ Holds properties of a paragraph style. """

    def __init__ (self):

        self.blockquote = False
        self.headingLevel = 0
        self.code = False
        self.title = False
        self.hasImg = False
        self.indented = 0

    def setBlockquote(self, value) :
        self.blockquote = value

    def setIndented (self, value) :
        self.indented = value

    def setHeading (self, level) :
        self.headingLevel = level

    def setTitle (self, value):
        self.title = value

    def setCode (self, value) :
        self.code = value

    def setHasImg (self, value) :
        self.hasImg = value

    def __str__ (self) :

        return "[bq=%s, h=%d, code=%s]" % (str(self.blockquote),
                                           self.headingLevel,
                                           str(self.code))


class ListProperties :
    """ Holds properties for a list style. """

    def __init__ (self):
        self.ordered = False
 
    def setOrdered (self, value) :
        self.ordered = value


    
class OpenDocumentTextFile :
    def __init__ (self, filepath, img_prefix) :
        self.footnotes = []
        self.footnoteCounter = 0
        self.textStyles = {"Standard" : TextProps()}
        self.paragraphStyles = {"Standard" : ParagraphProps()}
        self.listStyles = {}
        self.fixedFonts = []
        self.hasTitle = 0
        self.img_prefix = img_prefix
        self.imgs_num = 0
        self.previous_list_item = 0

        self.load(filepath)
        

    def processFontDeclarations (self, fontDecl) :
        """ Extracts necessary font information from a font-declaration
            element.
            """
        for fontFace in fontDecl.getElementsByTagName("style:font-face") :
            if fontFace.getAttribute("style:font-pitch") == "fixed" :
                self.fixedFonts.append(fontFace.getAttribute("style:name"))
        


    def extractTextProperties (self, style, parent=None) :
        """ Extracts text properties from a style element. """
        
        textProps = TextProps()
        
        if parent :
            parentProp = self.textStyles.get(parent, None)
            if parentProp :
                textProp = parentProp
            
        textPropEl = style.getElementsByTagName("style:text-properties")
        if not textPropEl : return textProps
        
        textPropEl = textPropEl[0]

        italic = textPropEl.getAttribute("fo:font-style")
        bold = textPropEl.getAttribute("fo:font-weight")

        textProps.setItalic(italic)
        textProps.setBold(bold)

        if textPropEl.getAttribute("style:font-name") in self.fixedFonts :
            textProps.setFixed(True)

        return textProps

    def extractParagraphProperties (self, style, parent=None) :
        """ Extracts paragraph properties from a style element. """

        paraProps = ParagraphProps()

        name = style.getAttribute("style:name")
        
        if name == "Quotations":
            paraProps.setBlockquote(True)

        if name.startswith("Heading_20_") :
            level = name[11:]
            try :
                level = int(level)
                paraProps.setHeading(level)
            except :
                level = 0

        if name == "Title" :
            paraProps.setTitle(True)
        
        paraPropEl = style.getElementsByTagName("style:paragraph-properties")
        if paraPropEl :
            paraPropEl = paraPropEl[0]
            leftMargin = paraPropEl.getAttribute("fo:margin-left")
            if leftMargin :
                try :
                    leftMargin = float(leftMargin[:-2])
                    if leftMargin > 0.01 :
                        paraProps.setIndented(True)
                except :
                    pass

        textProps = self.extractTextProperties(style)
        if textProps.fixed :
            paraProps.setCode(True)

        return paraProps
    

    def processStyles(self, styleElements) :
        """ Runs through "style" elements extracting necessary information.
            """

        for style in styleElements :

            name = style.getAttribute("style:name")

            if name == "Standard" : continue

            family = style.getAttribute("style:family")
            parent = style.getAttribute("style:parent-style-name")

            if family == "text" : 
                self.textStyles[name] = self.extractTextProperties(style,
                                                                   parent)

            elif family == "paragraph":
                self.paragraphStyles[name] = (
                                 self.extractParagraphProperties(style,
                                                                 parent))
    def processListStyles (self, listStyleElements) :

        for style in listStyleElements :
            name = style.getAttribute("style:name")

            prop = ListProperties()
            if style.childNodes :
                if ( style.childNodes[0].tagName
                     == "text:list-level-style-number" ) :
                    prop.setOrdered(True)

            self.listStyles[name] = prop
        

    def load(self, filepath) :
        """ Loads an ODT file. """
        
        zip = zipfile.ZipFile(filepath)

        for name in zip.namelist():
            if "Pictures" in name and not ".." in name:
                try:
                    os.mkdir("Pictures")
                except OSError:
                    pass
                zip.extract(name)

        styles_doc = xml.dom.minidom.parseString(zip.read("styles.xml"))
        self.processFontDeclarations(styles_doc.getElementsByTagName(
            "office:font-face-decls")[0])
        self.processStyles(styles_doc.getElementsByTagName("style:style"))
        self.processListStyles(styles_doc.getElementsByTagName(
            "text:list-style"))
        
        self.content = xml.dom.minidom.parseString(zip.read("content.xml"))
        self.processFontDeclarations(self.content.getElementsByTagName(
            "office:font-face-decls")[0])
        self.processStyles(self.content.getElementsByTagName("style:style"))
        self.processListStyles(self.content.getElementsByTagName(
            "text:list-style"))

    def compressCodeBlocks(self, text) :
        """ Removes extra blank lines from code blocks. """

        lines = text.split("\n")
        buffer = ""
        numLines = len(lines)
        for i in range(numLines) :
            
            if (lines[i].strip() or i == numLines-1  or i == 0 or
                not ( lines[i-1].startswith("    ")
                      and lines[i+1].startswith("    ") ) ):
                buffer += "\n" + lines[i]

        return buffer



    def listToString (self, listElement) :

        buffer = ""

        styleName = listElement.getAttribute("text:style-name")
        props = self.listStyles.get(styleName, ListProperties())
        

        if listElement.getAttribute("text:continue-numbering") != "true" :
            self.previous_list_item = 0
        
        for item in listElement.childNodes :
            self.previous_list_item += 1
            if props.ordered :
                number = str(self.previous_list_item)
                number = number + "." + " "*(2-len(number))
                buffer += number + self.paragraphToString(item.childNodes[0],
                                                        indent=3)
            else :
                buffer += "* " + self.paragraphToString(item.childNodes[0],
                                                        indent=2)
            buffer += "\n\n"
            
        return buffer

    def toString (self) :
        """ Converts the document to a string. """
        body = self.content.getElementsByTagName("office:body")[0]
        text = self.content.getElementsByTagName("office:text")[0]

        buffer = u""


        paragraphs = [el for el in text.childNodes
                      if el.tagName in ["text:p", "text:h",
                              "text:list"]]

        for paragraph in paragraphs :
            if paragraph.tagName == "text:list" :
                text = self.listToString(paragraph)
            else :
                text = self.paragraphToString(paragraph)
            if text :
                buffer += text + "\n\n"
            if self.footnotes :
                for cite, body in self.footnotes :
                    buffer += "  [^%s]: %s\n\n" % (cite, body)
                self.footnotes = []


        return self.compressCodeBlocks(buffer)


    def slugify(self, value):
        """
        from django/template/defaultfilters.py
        LICENSE: !!!!!!!
        Normalizes string, converts to lowercase, removes non-alpha characters,
        and converts spaces to hyphens.
        """
        import unicodedata, re
        value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore')
        value = unicode(re.sub('[^\w\s-]', '', value).strip().lower())
        value = unicode(re.sub(' ', '-', value))
        return value

    def textToString(self, element, props = None, format = True) :

        buffer = u""
        img_in_buffer = None

        for node in element.childNodes :

            if node.nodeType == xml.dom.Node.TEXT_NODE :
                buffer += node.nodeValue

            elif node.nodeType == xml.dom.Node.ELEMENT_NODE :
                tag = node.tagName

                if tag == "text:span" :

                    text = self.textToString(node) 

                    if not text.strip() :
                        continue  # don't apply styles to white space

                    styleName = node.getAttribute("text:style-name")
                    style = self.textStyles.get(styleName, None)

                    if format and style.fixed :
                        buffer += "`" + text + "`"
                        continue
                    
                    if format and style :
                        if style.italic and style.bold :
                            mark = "***"
                        elif style.italic :
                            mark = "_"
                        elif style.bold :
                            mark = "**"
                        else :
                            mark = ""
                    else :
                        mark = ""
                        #mark = "<" + styleName + ">"

                    buffer += "%s%s%s" % (mark, text, mark)
                    
                elif tag == "text:note" :
                    cite = (node.getElementsByTagName("text:note-citation")[0]
                                .childNodes[0].nodeValue)
                               
                    body = (node.getElementsByTagName("text:note-body")[0]
                                .childNodes[0])

                    self.footnotes.append((cite, self.textToString(body)))

                    buffer += "[^%s]" % cite

                elif tag in IGNORED_TAGS :
                    pass

                elif tag == "text:s" :
                    try :
                        num = int(node.getAttribute("text:c"))
                        buffer += " "*num
                    except :
                        buffer += " "

                elif tag == "text:tab" :
                    buffer += "    "


                elif tag == "text:a" :

                    text = self.textToString(node)
                    if format : 
                        link = node.getAttribute("xlink:href")
                        buffer += "[%s](%s)" % (text, link)
                    else :
                        buffer += text
                    
                elif tag == "text:bookmark" or tag == "text:bookmark-end":
                    # YOAV - need to add an # link here
                    pass
                elif tag == "text:line-break":
                    # YOAV - need to add an <br/> here
                    if props:
                        props.setCode(True)
                    buffer += "\n"
                elif tag == "text:soft-page-break":
                    pass
                elif tag == "draw:frame":
                    child = node.childNodes[0]
                    img_in_buffer = child.getAttribute("xlink:href")
                else :
                    buffer += " {" + tag + "} "

        if format and img_in_buffer:
            self.imgs_num += 1
            extension = img_in_buffer.split('.')[-1]
            legend = ""
            prefix = ""
            imgname = ""
            if len(buffer) > 200 :
                legend = ""
                imgname = "img/" + self.img_prefix + self.slugify(buffer)[:50] + "." + extension
                prefix = buffer + "\n\n"
            else :
                legend = buffer
                imgname = "img/" + self.img_prefix + self.slugify(buffer) + "." + extension
                prefix = ""
            buffer = prefix + "![" + legend + "](" + imgname + ")"
            if os.path.exists(img_in_buffer) and (img_in_buffer[:9] != "./Object ") :
                # print  >> sys.stderr, "Try : " + img_in_buffer + " -> " + imgname + "\n"
                os.rename(img_in_buffer, imgname)
            else :
                buffer += "\n/!\\ MISSING IMAGE /!\\ "
                print  >> sys.stderr, "Warning: Missing image "+imgname+" ("+img_in_buffer+")\n"

            
        if format and props:
            props.setHasImg(img_in_buffer != None)

        return buffer

    def paragraphToString(self, paragraph, indent = 0) :


        style_name = paragraph.getAttribute("text:style-name")
        paraProps = self.paragraphStyles.get(style_name) #, None)
        heading_level = paragraph.getAttribute("text:outline-level")
        if len(heading_level) > 0:
            heading_level = int(heading_level)
            if heading_level > 0:
                paraProps.setHeading(heading_level)
        text = self.textToString(paragraph, paraProps)

        #print >>sys.stderr, "TEXT:", text

        if paraProps and not paraProps.code :
            text = text.strip()

        if paraProps.title :
            self.hasTitle = 1
            #print >>sys.stderr, "TITLE"
            return text + "\n" + ("=" * len(text))

        if paraProps.headingLevel :

            #print >>sys.stderr, "HEADING"
            level = paraProps.headingLevel
            if self.hasTitle : level += 1

            if level == 1 :
                return text + "\n" + ("=" * len(text))
            elif level == 2 :
                return text + "\n" + ("-" * len(text))
            else :
                return "#" * level + " " + text

        elif paraProps.code:
            #lines = ["    %s" % line for line in text.split("\n")]
            #print >>sys.stderr, "CODE"
            text = self.textToString(paragraph, paraProps, False).strip()
            classnames = [ ]
            if text[:7] == "HTTP/1." :
                classnames.append( ".http .response" )
            elif re.match("^(GET|POST|DELETE|PUT|HEAD) /", text) :
                classnames.append( ".http .request")
            elif text[:5] == "<?php" :
                classnames.append( ".php" )
            elif text[:15] == "<!DOCTYPE HTML>" or text[:15] == "<!DOCTYPE html>" :
                classnames.append( ".html")
            elif text[:6] == "<?xml " :
                classnames.append( ".xml")
            if text.find("\n") == -1 :
                classnames.append( ".oneline" )
            prefix = ""
            if len(classnames) :
                prefix = " {" + " ".join(classnames) + "}"
            return "~~~~~~~" + prefix + "\n" + text + "\n~~~~~~~"
        elif paraProps.hasImg:
            #print >>sys.stderr, "HAS_IMG"
            return text
        
        if paraProps.blockquote :
            return self.wrapParagraph(text, indent = indent, blockquote = True)

        else :
            #print >>sys.stderr, "WRAP"
            return self.wrapParagraph(text, indent = indent)
        

    def wrapParagraph(self, text, indent = 0, blockquote=False) :

        counter = 0
        buffer = ""
        LIMIT = 50

        if blockquote :
            buffer += "> "
        
        for token in text.split() :

            if counter > LIMIT - indent :
                buffer += "\n" + " "*indent
                if blockquote :
                    buffer += "> "
                counter = 0

            buffer += token + " "
            counter += len(token)

        return buffer

if __name__ == "__main__" :
    filename = ""
    img_prefix = ""
    if len(sys.argv) >= 3:
        img_prefix = sys.argv[2]
    if len(sys.argv) <= 1:
        print >>sys.stderr, "Usage:", sys.argv[0], "<File name>", "<Optional image prefix>"
        quit()

    filename = sys.argv[1]

    odt = OpenDocumentTextFile(filename, img_prefix )
    unicode = odt.toString()
    unicode = unicode.replace(u'\u2019', "'")
    out_utf8 = unicode.encode("utf-8")
    sys.stdout.write(out_utf8)
    shutil.rmtree("Pictures")

