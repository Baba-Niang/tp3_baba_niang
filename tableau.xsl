<?xml version="1.0" encoding="UTF-8"?>
<!-- ISEPAT202603271 — Niang Baba -->
<!-- TP Module 3 (étudiants) — tableau.xsl, version finale (étapes 4 à 9) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Étape 5 : le seuil d'admission, modifiable en un seul endroit -->
  <xsl:param name="seuil" select="10"/>

  <!-- Étape 8 : index des étudiants par classe (regroupement de Muench) -->
  <xsl:key name="par-classe" match="etudiant" use="@classe"/>

  <!-- ========== Étape 4 : la page HTML complète ========== -->
  <xsl:template match="/">
    <html lang="fr">
      <head>
        <meta charset="UTF-8"/>
        <title>Promotion <xsl:value-of select="promotion/@filiere"/></title>
        <link rel="stylesheet" href="style.css"/>
      </head>
      <body>
        <header>
          <h1>Promotion <xsl:value-of select="promotion/@filiere"/></h1>
          <p>Année <xsl:value-of select="promotion/@annee"/></p>
        </header>
        <main>
          <!-- Étape 7 : les chiffres clés -->
          <xsl:call-template name="stats"/>

          <!-- Étape 8 : un titre et un tableau par classe.
               On garde, pour chaque classe, le PREMIER étudiant rencontré :
               son generate-id() est égal à celui du premier nœud renvoyé par key(). -->
          <xsl:for-each select="promotion/etudiant[generate-id() = generate-id(key('par-classe', @classe)[1])]">
            <xsl:sort select="@classe"/>
            <xsl:variable name="classe" select="@classe"/>
            <xsl:variable name="membres" select="key('par-classe', $classe)"/>
            <h2>
              <xsl:text>Classe </xsl:text>
              <xsl:value-of select="$classe"/>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="count($membres)"/>
              <xsl:text> étudiants)</xsl:text>
            </h2>
            <xsl:call-template name="tableau">
              <xsl:with-param name="etudiants" select="$membres"/>
            </xsl:call-template>
          </xsl:for-each>
        </main>
        <footer>Page générée par XSLT à partir de etudiants.xml</footer>
      </body>
    </html>
  </xsl:template>

  <!-- ========== Étape 7 : quatre cartes, chaque valeur calculée par XPath ========== -->
  <xsl:template name="stats">
    <div class="stats">
      <div class="carte">
        <span class="valeur"><xsl:value-of select="count(//etudiant)"/></span>
        <span class="legende">étudiants</span>
      </div>
      <div class="carte">
        <span class="valeur">
          <xsl:value-of select="count(//etudiant[sum(notes/note) div count(notes/note) &gt;= $seuil])"/>
        </span>
        <span class="legende">admis (moyenne ≥ <xsl:value-of select="$seuil"/>)</span>
      </div>
      <div class="carte">
        <span class="valeur">
          <xsl:value-of select="format-number(sum(//note[@matiere='XML']) div count(//note[@matiere='XML']), '0.00')"/>
        </span>
        <span class="legende">moyenne en XML</span>
      </div>
      <div class="carte">
        <span class="valeur"><xsl:value-of select="count(//etudiant[not(email)])"/></span>
        <span class="legende">emails manquants</span>
      </div>
    </div>
  </xsl:template>

  <!-- ========== Le tableau d'un groupe d'étudiants ========== -->
  <xsl:template name="tableau">
    <xsl:param name="etudiants"/>
    <table>
      <thead>
        <tr>
          <th>Rang</th>
          <th>Matricule</th>
          <th>Nom</th>
          <th>Prénom</th>
          <th>Classe</th>
          <th>Email</th>
          <th>Moyenne</th>
          <th>Résultat</th>
        </tr>
      </thead>
      <tbody>
        <!-- Étape 6 : tri par moyenne décroissante, en mode NUMÉRIQUE -->
        <xsl:apply-templates select="$etudiants">
          <xsl:sort select="sum(notes/note) div count(notes/note)" data-type="number" order="descending"/>
        </xsl:apply-templates>
      </tbody>
    </table>
  </xsl:template>

  <!-- ========== Une ligne par étudiant ========== -->
  <xsl:template match="etudiant">
    <!-- Moyenne de l'étudiant : somme de ses notes / nombre de ses notes -->
    <xsl:variable name="moy" select="sum(notes/note) div count(notes/note)"/>
    <tr>
      <!-- Étape 9 : la classe major sur la première ligne du tableau.
           xsl:attribute doit venir AVANT tout contenu de <tr> (ici avant le premier <td>). -->
      <xsl:if test="position() = 1">
        <xsl:attribute name="class">major</xsl:attribute>
      </xsl:if>

      <!-- Étape 6 : position() donne le rang dans la liste triée (1, 2, 3…) -->
      <td class="rang"><xsl:value-of select="position()"/></td>
      <td><xsl:value-of select="@matricule"/></td>
      <td><xsl:value-of select="nom"/></td>
      <td><xsl:value-of select="prenom"/></td>
      <td><xsl:value-of select="@classe"/></td>

      <!-- Étape 5 : email absent -->
      <td>
        <xsl:choose>
          <xsl:when test="email">
            <xsl:value-of select="email"/>
          </xsl:when>
          <xsl:otherwise>
            <span class="absent">non renseigné</span>
          </xsl:otherwise>
        </xsl:choose>
      </td>

      <!-- Étape 4 : moyenne à deux décimales -->
      <td class="moyenne"><xsl:value-of select="format-number($moy, '0.00')"/></td>

      <!-- Étape 5 : badge selon le seuil -->
      <td>
        <xsl:choose>
          <xsl:when test="$moy &gt;= $seuil">
            <span class="badge reussite">Admis</span>
          </xsl:when>
          <xsl:otherwise>
            <span class="badge echec">À revoir</span>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
