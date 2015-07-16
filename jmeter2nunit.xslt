<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="no" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />
	<xsl:param name="date"/>
	<xsl:param name="time"/>
	<xsl:param name="report_name"/>
	<xsl:param name="num_failures" select="count(//assertionResult[failure = 'true'])" />
	<xsl:param name="num_errors" select="count(//assertionResult[error = 'true'])"/>

	<xsl:template match="/">
		<test-results not-run="0" inconclusive="0" ignored="0" skipped="0" invalid="0">

			<xsl:attribute name="total">
				<xsl:value-of select="count(//httpSample) + count(//sample)"/>
			</xsl:attribute>
			<xsl:attribute name="date">
				<xsl:value-of select="$date"/>
			</xsl:attribute>
			<xsl:attribute name="time">
				<xsl:value-of select="$time"/>
			</xsl:attribute>
			<xsl:attribute name="name">
				<xsl:value-of select="$report_name"/>
			</xsl:attribute>
			<xsl:attribute name="failures">
				<xsl:value-of select="$num_failures"/>
			</xsl:attribute>
			<xsl:attribute name="errors">
				<xsl:value-of select="$num_errors"/>
			</xsl:attribute>

			<test-suite type="TestFixture" name="Tests" description="" executed="True" result="Failure" success="False" time="0.724" >
				<xsl:attribute name="asserts">
					<xsl:value-of select="$num_failures"/>
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="$num_failures > 0">
						<xsl:attribute name="success">False</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="success">True</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$num_failures > 0">
						<xsl:attribute name="result">Failure</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="result">Success</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<results>
					<xsl:apply-templates/>
				</results>
			</test-suite>

		</test-results>
	</xsl:template>

	<xsl:template match="httpSample | sample">
		<test-case description="" executed="True">

			<xsl:attribute name="name">
				<xsl:value-of select="@lb"/>
			</xsl:attribute>

			<xsl:attribute name="time">
				<xsl:value-of select="@lt"/>
			</xsl:attribute>

			<xsl:attribute name="asserts">
				<xsl:value-of select="count(./assertionResult[failure = 'true'])"/>
			</xsl:attribute>

			<xsl:choose>
				<xsl:when test="./assertionResult[failure = 'true']">
					<xsl:attribute name="success">False</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="success">True</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="./assertionResult[failure = 'true']">
					<xsl:attribute name="result">Failure</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="result">Success</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="child::assertionResult[failure = 'true']"/>

		</test-case>

	</xsl:template>

	<xsl:template match="assertionResult[failure = 'true']">
		<failure>
			<message>
				HTTP Response Code:<br/>
				<xsl:value-of select="./../@rc"/><br/>
				JMeter Response Message:<br/>
				<xsl:value-of select="./../@rm"/><br/>
				JMeter Failure Message:<br/>
				<xsl:value-of select="./failureMessage"/><br/>
			</message>
		</failure>
	</xsl:template>

</xsl:stylesheet>
