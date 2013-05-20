# Release notes

This document is a list of user visible feature changes made between
releases except for bug fixes.

Note that each entry is kept so brief that no reason behind or
reference information is supplied with.  For a full list of changes
with all sufficient information, see the git(1) log.

A lot more is coming soon check out the issue tagged as `feature`
in the tracker.

## Part of 0.1.1

* Bug fix: do not summarize undocumented parameters.

## Part of the first release 0.1.0

* Feature: An engine to render and deploy the REST API documentation.
* Feature: Filter to validate requests/responses.
* Feature: Sanitizer to promote validated parameter value to a more precise type.
* Feature: Schema are organize like controllers and views.
* Feature: Follow [JSON schema draft v3 standard](http://tools.ietf.org/id/draft-zyp-json-schema-03.html) to represents schema.
* Feature: A RequestValidationError exception handler.
