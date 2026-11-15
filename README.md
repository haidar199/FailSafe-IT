# FailSafe-IT
1NF: Varje fält innehåller ett enda värde, alltså inga listor. Varje tabell har en primärnyckel, Id, som identifierar varje rad.

2NF: Tabellerna uppfyller 1NF och alla övriga kolumner beror på hela primärnyckeln. Eftersom primärnyckeln består av en enda kolumn finns det inga partiella beroenden.

3NF: Tabellerna uppfyller 2NF och det finns inga transitiva beroenden, alltså att en kolumn som inte är en nyckel beror på en annan kolumn som inte är en nyckel. Jag har delat upp kunder, konsulter och uppdrag i egna tabeller. Uppdragstabellen använder främmande nycklar för att koppla ihop kunden och konsulten. Därför behöver deras namn och kontaktuppgifter inte upprepas för varje uppdrag.
