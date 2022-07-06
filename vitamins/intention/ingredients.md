---
title: "PhenomX Vitamins"
---
# {{page.title}}

> {{site.data.ingredients.note}}
<br>~{{site.data.ingredients.preparator}}
{% for i in site.data.ingredients.composition %}
{{forloop.index}}. {{i}}
{% endfor %}

note: Good for {{site.data.ingredients.purpose}}
