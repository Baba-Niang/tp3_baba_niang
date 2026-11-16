<?xml version="1.0" encoding="UTF-8"?>
<!-- ISEPAT202603271 — Niang Baba -->
<!-- TP Module 3 (étudiants) — Étape 3 : une liste <ul>, un <li> par étudiant (Prénom Nom) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Règle de la racine : ouvre la liste et traite chaque étudiant -->
  <xsl:template match="/">
    <ul>
      <xsl:apply-templates select="promotion/etudiant"/>
    </ul>
  </xsl:template>

  <!-- Règle d'un étudiant : « Prénom Nom » -->
  <xsl:template match="etudiant">
    <li>
      <xsl:value-of select="prenom"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="nom"/>
    </li>
  </xsl:template>
</xsl:stylesheet>
