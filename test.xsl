<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/">
<xsl:text disable-output-escaping="yes">&lt;?php
  echo "Hello from generated PHP!";
?&gt;
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
