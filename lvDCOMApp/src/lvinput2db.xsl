<?xml version="1.0" encoding="UTF-8"?>
<!--
    ########### SVN repository information ###################
    # $LastChangedDate$
    # $LastChangedBy$
    # $LastChangedRevision$
    # $HeadURL$
    ########### SVN repository information ###################

    Usage: xsltproc lvinput2db.xsl lvinput.xml > epics_records.db

	lvinput.xml is the output of a prior run of lvstrings2input.xsl
	
	@file lvinput2db.xsl Process a lvDCOM XML configuration file to generate EPICS DB records
	@author Freddie Akeroyd, STFC ISIS Facility, UK
	
-->
<xsl:stylesheet
    version="1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lvdcom="http://epics.isis.rl.ac.uk/lvDCOMinput/1.0">
    
    <xsl:output method="text" indent="yes" />

   <xsl:template match="/lvdcom:lvinput">
# Initially generated by $Id$
# 
# auto-generated EPICS records specify an asyn port "lvfp", but this can be changed - it just needs
# to match the first argument of the relevant lvDCOMConfigure() command in the IOC st.cmd 
# 
      <xsl:apply-templates select="lvdcom:section" />
	</xsl:template>
	
   <xsl:template match="lvdcom:section">
      <xsl:variable name="section_name" select="@name" />
# 
# Definitions from configSection "<xsl:value-of select="$section_name"/>" in XML input file
#
#     lvDCOMConfigure("lvfp", "<xsl:value-of select="$section_name"/>", "/path/to/lvinput.xml")
# 
      <xsl:apply-templates select="lvdcom:vi" />
	</xsl:template>

   <xsl:template match="lvdcom:vi">
      <xsl:variable name="vi_path" select="@path" />
      <xsl:apply-templates select="lvdcom:param">
          <xsl:with-param name="vi_path" select="$vi_path" />
      </xsl:apply-templates> 
   </xsl:template>
   
   <xsl:template match="lvdcom:param">
      <xsl:param name="vi_path"/>
      <xsl:variable name="asyn_param" select="@name" />
      <xsl:variable name="lv_read" select="lvdcom:read/@target" />
      <xsl:variable name="lv_set" select="lvdcom:set/@target" />
      <xsl:variable name="asyn_type">
	    <xsl:call-template name="convertToAsynType">
	      <xsl:with-param name="vartype" select="@type" />
	    </xsl:call-template>
	  </xsl:variable>

<xsl:choose>
<xsl:when test="@type = 'string'">
# Read LabVIEW control/indicator "<xsl:value-of select="$lv_read"/>" on "<xsl:value-of select="$vi_path"/>"
record(stringin, "$(P)<xsl:value-of select="$asyn_param"/>_RBV")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_read"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>Read")
    field(INP,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(SCAN, ".1 second")
}

# Write to LabVIEW control "<xsl:value-of select="$lv_set"/>" on "<xsl:value-of select="$vi_path"/>"
record(stringout, "$(P)<xsl:value-of select="$asyn_param"/>")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_set"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>Write")
    field(OUT,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
}

</xsl:when>	
<xsl:when test="@type = 'int32'">
# Read LabVIEW control/indicator "<xsl:value-of select="$lv_read"/>" on "<xsl:value-of select="$vi_path"/>"
record(longin, "$(P)<xsl:value-of select="$asyn_param"/>_RBV")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_read"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(INP,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(SCAN, ".1 second")
}
	        
# Write to LabVIEW control "<xsl:value-of select="$lv_set"/>" on "<xsl:value-of select="$vi_path"/>"
record(longout, "$(P)<xsl:value-of select="$asyn_param"/>")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_set"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(OUT,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
}

</xsl:when>
<xsl:when test="@type = 'float64'">
# Read LabVIEW control/indicator "<xsl:value-of select="$lv_read"/>" on "<xsl:value-of select="$vi_path"/>"
record(ai, "$(P)<xsl:value-of select="$asyn_param"/>_RBV")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_read"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(INP,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(PREC, "3")
    field(SCAN, ".1 second")
}

# Write to LabVIEW control "<xsl:value-of select="$lv_set"/>" on "<xsl:value-of select="$vi_path"/>"
record(ao, "$(P)<xsl:value-of select="$asyn_param"/>")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_set"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(OUT,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(PREC, "3")
}

</xsl:when>
<xsl:when test="@type = 'boolean'">
    <xsl:variable name="zname">
        <xsl:call-template name="formatMBString"><xsl:with-param name="value" select="lvdcom:items/lvdcom:item[@value=0]/@name"></xsl:with-param></xsl:call-template>
    </xsl:variable>
    <xsl:variable name="oname">
        <xsl:call-template name="formatMBString"><xsl:with-param name="value" select="lvdcom:items/lvdcom:item[@value=1]/@name"></xsl:with-param></xsl:call-template>
    </xsl:variable>
# Read LabVIEW control/indicator "<xsl:value-of select="$lv_read"/>" on "<xsl:value-of select="$vi_path"/>"
record(bi, "$(P)<xsl:value-of select="$asyn_param"/>_RBV")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_read"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(INP,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(SCAN, ".1 second")
    field(ZNAM, "<xsl:value-of select="$zname"/>")
    field(ONAM, "<xsl:value-of select="$oname"/>")
}

# Write to LabVIEW control "<xsl:value-of select="$lv_set"/>" on "<xsl:value-of select="$vi_path"/>"
record(bo, "$(P)<xsl:value-of select="$asyn_param"/>")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_set"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(OUT,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(ZNAM, "<xsl:value-of select="$zname"/>")
    field(ONAM, "<xsl:value-of select="$oname"/>")
}

</xsl:when>
<xsl:when test="@type = 'ring' or @type = 'enum'">
# Read LabVIEW control/indicator "<xsl:value-of select="$lv_read"/>" on "<xsl:value-of select="$vi_path"/>"
record(mbbi, "$(P)<xsl:value-of select="$asyn_param"/>_RBV")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_read"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(INP,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
    field(SCAN, ".1 second")
<xsl:call-template name="allmb" />
}

# Write to LabVIEW control "<xsl:value-of select="$lv_set"/>" on "<xsl:value-of select="$vi_path"/>"
record(mbbo, "$(P)<xsl:value-of select="$asyn_param"/>")
{
	field(DESC, "LabVIEW '<xsl:value-of select="$lv_set"/>'")
    field(DTYP, "<xsl:value-of select="$asyn_type"/>")
    field(OUT,  "@asyn(lvfp,0,0)<xsl:value-of select="$asyn_param"/>")
<xsl:call-template name="allmb" />
}

</xsl:when>
<xsl:otherwise>
#
# ERROR type "<xsl:value-of select="@type"/>" for "<xsl:value-of select="$lv_read"/>" / "<xsl:value-of select="$lv_read"/>" is invalid on "<xsl:value-of select="$vi_path"/>"
#

</xsl:otherwise>
</xsl:choose>

    </xsl:template>

    <!-- record length in mbbi/mbbo is 26 chars = 25 + \0 -->
    <xsl:template name="formatMBString">  
        <xsl:param name="value" />
        <xsl:choose>
            <xsl:when test="string-length($value) &lt; 26">
                <xsl:value-of select="$value"/>
            </xsl:when>
            <xsl:when test="string-length(normalize-space($value)) &lt; 26">
                <xsl:value-of select="normalize-space($value)"/>
            </xsl:when>
            <xsl:when test="string-length(translate($value, ' ', '')) &lt; 26">
                <xsl:value-of select="translate($value, ' ', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="substring(translate($value, ' ', ''), 1, 25)"/>               
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <xsl:template name="allmb">
       <xsl:call-template name="mb"><xsl:with-param name="prefix">ZR</xsl:with-param><xsl:with-param name="pos">1</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">ON</xsl:with-param><xsl:with-param name="pos">2</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">TW</xsl:with-param><xsl:with-param name="pos">3</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">TH</xsl:with-param><xsl:with-param name="pos">4</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">FR</xsl:with-param><xsl:with-param name="pos">5</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">FV</xsl:with-param><xsl:with-param name="pos">6</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">SX</xsl:with-param><xsl:with-param name="pos">7</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">SV</xsl:with-param><xsl:with-param name="pos">8</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">EI</xsl:with-param><xsl:with-param name="pos">9</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">NI</xsl:with-param><xsl:with-param name="pos">10</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">TE</xsl:with-param><xsl:with-param name="pos">11</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">EL</xsl:with-param><xsl:with-param name="pos">12</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">TV</xsl:with-param><xsl:with-param name="pos">13</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">TT</xsl:with-param><xsl:with-param name="pos">14</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">FT</xsl:with-param><xsl:with-param name="pos">15</xsl:with-param></xsl:call-template>
       <xsl:call-template name="mb"><xsl:with-param name="prefix">FF</xsl:with-param><xsl:with-param name="pos">16</xsl:with-param></xsl:call-template>
    </xsl:template>

    <xsl:template name="mb">
        <xsl:param name="prefix" />
        <xsl:param name="pos" />
        <xsl:variable name="node" select="lvdcom:items/lvdcom:item[position()=$pos]" />
        <xsl:if test="$node">
            <xsl:variable name="tname">
                <xsl:call-template name="formatMBString"><xsl:with-param name="value" select="$node/@name"></xsl:with-param></xsl:call-template>
            </xsl:variable>
    field(<xsl:value-of select="$prefix"/>VL, <xsl:value-of select="$node/@value"/>)
    field(<xsl:value-of select="$prefix"/>ST, "<xsl:value-of select="$tname"/>")
        </xsl:if>
    </xsl:template>

    <xsl:template name="convertToAsynType">
	<xsl:param name="vartype" />
	<xsl:choose>
        <xsl:when test="$vartype = 'int32'">asynInt32</xsl:when>
        <xsl:when test="$vartype = 'enum'">asynInt32</xsl:when>
        <xsl:when test="$vartype = 'ring'">asynInt32</xsl:when>
        <xsl:when test="$vartype = 'boolean'">asynInt32</xsl:when>
        <xsl:when test="$vartype = 'float64'">asynFloat64</xsl:when>
        <xsl:when test="$vartype = 'string'">asynOctet</xsl:when>
		<xsl:otherwise>invalid</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>

</xsl:stylesheet>
<!-- asynFloat64ArrayIn  -->
<!--
   /CONTENT/CONTROL/@type    Numeric(ID=80)  String(ID=81)  Array(ID=82) Boolean(ID=79)    Cluster    "Radio Buttons" "Ring" "Listbox" "Enum" "Type Definition"
	/CONTENT/CONTROL/@name
	
	if array, /CONTENT/CONTROL/CONTENT/CONTROL/@type  Numeric
-->
