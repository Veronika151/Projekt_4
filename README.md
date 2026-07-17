# 📊 SQL Projekt

<p align="center">
  <b>Dostupnost základních potravin široké veřejnosti </b>
</p>

---

## 📖 Popis projektu

Na analytickém oddělení nezávislé společnosti zaměřené na sledování životní úrovně občanů bylo stanoveno několik výzkumných otázek, jejichž cílem je vyhodnotit dostupnost základních potravin pro širokou veřejnost.

Úkolem projektu je připravit kvalitní datové podklady, které umožní porovnat dostupnost vybraných potravin vzhledem k průměrným příjmům občanů České republiky v definovaném časovém období.

Výsledné analýzy budou sloužit jako podklad pro tiskové oddělení společnosti, které bude prezentovat získané informace na konferenci zaměřené na životní úroveň obyvatel.

Součástí projektu je také vytvoření doplňkové datové sady obsahující ekonomické ukazatele dalších evropských států, konkrétně:

- hrubý domácí produkt (HDP),
- GINI koeficient,
- počet obyvatel.

Tyto údaje umožní porovnat ekonomickou situaci České republiky s ostatními evropskými státy ve stejném časovém období.

---

## 🗂️ Použité tabulky

Projekt využívá dvě výsledné tabulky:

**Primární tabulka:** [primary_table.sql](sql/primary_table.sql)

Obsahuje propojená data o:

- průměrných mzdách podle odvětví,
- průměrných cenách vybraných potravin,
- jednotlivých letech.

**Sekundární tabulka:** [secondary_table.sql](sql/secondary_tabel.sql)

Obsahuje makroekonomické ukazatele jednotlivých států:

- HDP (GDP),
- počet obyvatel,
- Giniho koeficient.

---

## ⚙️ Postup zpracování

1. Byla vytvořena primární tabulka propojující data o mzdách a cenách potravin.
2. Byla vytvořena sekundární tabulka obsahující makroekonomické ukazatele.
3. Nad výslednými tabulkami byly vytvořeny SQL dotazy odpovídající jednotlivým výzkumným otázkám.
4. Výsledky byly interpretovány na základě získaných dat.

---

## 📌 Informace o výstupních datech

- Analýza pracuje s průměrnými hodnotami mezd a cen potravin.
- Meziroční změny lze vyhodnotit až od roku **2007**, protože rok **2006** nemá předchozí srovnávací období.
- U výzkumné otázky č. 5 byla použita pouze data pro **Czech Republic**.
- Analýza hodnotí vztahy mezi sledovanými ukazateli na základě dostupných dat a neprokazuje příčinné souvislosti.

---

## 📈 Výzkumné otázky

**📊 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

Výsledky analýzy ukazují, že mzdy v jednotlivých odvětvích mezi roky 2006 a 2018 obecně rostly, avšak růst nebyl rovnoměrný ve všech sektorech. V některých letech a odvětvích došlo k meziročnímu poklesu mezd. Nejvýraznější pokles byl zaznamenán v roce 2013, především v odvětví peněžnictví a pojišťovnictví, kde mzdy klesly téměř o 9 %. Další významnější poklesy byly například v odvětví Výroba a rozvod elektřiny, plynu, tepla a klimatizovaného vzduchu (−4,44 % v roce 2013) nebo Těžba a dobývání (−3,24 % v roce 2013).

_Závěr:_
Mzdy nerostou ve všech letech bez výjimky, protože některá odvětví zaznamenala meziroční pokles. Celkový trend mezi roky 2007–2018 je však jednoznačně růstový – ve všech odvětvích došlo k celkovému zvýšení průměrné mzdy.

**SQL skript:** [question_1.sql](sql/question_1.sql)

---

**🥛 2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

V prvním srovnatelném období (2006) bylo možné za průměrnou mzdu koupit přibližně **1 312 kg konzumního chleba** nebo **1 465 litrů polotučného mléka**.

V posledním sledovaném období (2018) vzrostla kupní síla na přibližně **1 365 kg chleba** a **1 669 litrů mléka**.

Ve sledovaném období se kupní síla obyvatel zvýšila. Přestože ceny chleba i mléka vzrostly, růst průměrných mezd byl vyšší než růst cen těchto potravin. Oproti roku 2006 bylo možné v roce 2018 koupit přibližně o **53 kg chleba** a **204 l mléka** více.

**SQL skript:** [question_2.sql](sql/question_2.sql)

---

**🛒 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Nejnižší průměrný meziroční růst ceny byl zjištěn u kategorie **Cukr krystalový**. Průměrná meziroční změna ceny činila **−1,92 %**, což znamená, že se cena této potraviny se během sledovaného období v průměru meziročně snižovala.

Na rozdíl od většiny ostatních sledovaných kategorií potravin tak cukr dlouhodobě nezdražoval, ale vykazoval mírný pokles průměrné ceny.

**SQL skript:** [question_3.sql](sql/question_3.sql)

---

**📉 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

Ve sledovaném období nebyl zaznamenán žádný rok, ve kterém by meziroční růst cen potravin převýšil růst mezd o více než **10 procentních bodů**.

Největší rozdíl mezi meziročním růstem cen potravin a mezd byl zaznamenán v roce **2013**, kdy ceny potravin vzrostly v průměru o **6,01 %**, zatímco průměrné mzdy meziročně klesly o **0,78 %**. Rozdíl činil **6,79 procentního bodu**.

Naopak největší rozdíl ve prospěch mezd nastal v roce **2009**, kdy průměrné mzdy vzrostly o **2,84 %**, zatímco ceny potravin klesly o **6,59 %**. Rozdíl dosáhl **−9,43 procentního bodu**.

**SQL skript:** [question_4.sql](sql/question_4.sql)

---

**📈 5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?**

Pro posouzení možného vlivu HDP byly porovnány meziroční změny HDP s meziročním růstem mezd a cen potravin ve stejném i následujícím roce.

Výsledky **neprokázaly jednoznačný vztah** mezi růstem HDP a vývojem mezd nebo cen potravin. Například v roce **2009** HDP meziročně kleslo o **4,66 %**, přesto mzdy vzrostly o **2,84 %**, zatímco ceny potravin klesly o **6,59 %**. Naopak v roce **2017** byl zaznamenán současný růst HDP (**5,17 %**), mezd (**6,40 %**) i cen potravin (**7,06 %**), což může naznačovat určitou souvislost.

Při porovnání s následujícím rokem se však obdobný vývoj **neprojevoval pravidelně**. Na základě dostupných dat proto **nelze potvrdit, že vyšší růst HDP pravidelně vede k výraznějšímu růstu mezd nebo cen potravin ve stejném ani následujícím roce.**

**SQL skript:** [question_5.sql](sql/question_5.sql)

---

## ✅ Výstup projektu

Výsledkem projektu jsou dvě finální tabulky a pět SQL dotazů odpovídajících jednotlivým výzkumným otázkám, včetně jejich interpretace.
