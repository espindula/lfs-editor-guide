<?xml version='1.0' encoding='ISO-8859-1'?>

<!--
$LastChangedBy: pierre $
$Date: 2020-03-13 09:38:37 -0500 (Fri, 13 Mar 2020) $
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <!-- Stylesheet to create profiled XML output.
       Replaces {docbook-xsl}/profiling/profile.xsl -->

  <!-- Include common profiling stylesheet -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/profiling/profile-mode.xsl"/>

  <!-- This file must be included, because profile-mode uses
       templates from it -->
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/common/stripns.xsl"/>

  <!-- In two pass processing there is no need for the base URI fixup -->
  <xsl:param name="profile.baseuri.fixup" select="false()"/>

  <!-- Generate DocBook instance with correct DOCTYPE -->
  <xsl:output method="xml"
              doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
              doctype-system="http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"/>

  <!-- Profiling parameters:
       profile.separator changed from ";" to "," to let it work on the command
       line. -->
  <xsl:param name="profile.arch" select="''"/>
  <xsl:param name="profile.audience" select="''"/>
  <xsl:param name="profile.condition" select="''"/>
  <xsl:param name="profile.conformance" select="''"/>
  <xsl:param name="profile.lang" select="''"/>
  <xsl:param name="profile.os" select="''"/>
  <xsl:param name="profile.revision" select="''"/>
  <xsl:param name="profile.revisionflag" select="''"/>
  <xsl:param name="profile.role" select="''"/>
  <xsl:param name="profile.security" select="''"/>
  <xsl:param name="profile.status" select="''"/>
  <xsl:param name="profile.userlevel" select="''"/>
  <xsl:param name="profile.vendor" select="''"/>
  <xsl:param name="profile.wordsize" select="''"/>
  <xsl:param name="profile.attribute" select="''"/>
  <xsl:param name="profile.value" select="''"/>
  <xsl:param name="profile.separator" select="','"/>

  <!-- Call common profiling mode -->
  <xsl:template match="/">
    <xsl:apply-templates select="." mode="profile"/>
  </xsl:template>

</xsl:stylesheet>