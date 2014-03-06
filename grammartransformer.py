import re

# Dictionary: {tokenstring: tokenname}
TOKENS = dict((l.split(" ") for l in open("tokens.txt").read().splitlines()))

# A simple bottom up parser for the rule production
# Scans the production bakwards, that makes dealing
# with the '*' and '+' operators much simpler.
# Note: Language of regexps forms a CFG.

class ProductionLexer:
    @staticmethod
    def _tokentype(tokenstr):
        if 'a' <= tokenstr[0] <= 'z': return 'a' # Non-terminal
        elif 'A' <= tokenstr[0] <= 'Z': return 'A' # Terminal
        else: return tokenstr[0]

    def __init__(self, production):
        self.tokens = [
                (t, self._tokentype(t)) if self._tokentype(t) != "'" \
                    else (TOKENS[t[1:-1]], 'A')
                  for t in re.findall(
                      r"(\(|\)|\[|\]|\||'.*?'|\*|\+|[a-z_]+|[A-Z]+)",
                      production)]

    def nextToken(self):
        try:
            return self.tokens.pop()
        except IndexError:
            return None, None

    def lookup(self):
        try:
            return self.tokens[-1]
        except IndexError:
            return None, None

count = 0
# A simple top-down parser for the regexp language
class ProductionParser:
    def _generatename(self):
        global count
        count += 1
        return "s"+str(count)

    def __init__(self, production):
        self.lexer = ProductionLexer(production)
        self.addedrules = {}
        self.count = 0

    def S(self):
        res = self.A()
        while self.lexer.lookup()[1] in ('|','A','a','*','+',']',')'):
            if self.lexer.lookup()[0] == '|':
                self.lexer.nextToken()
                res = self.A() + " | " + res
            else:
                res = self.A() + " " + res

        #res = self.A() + " " + res
        return re.sub(" +", " ", res).strip()

    def A(self):
        res = ""
        while self.lexer.lookup()[1] in ('a','A'):
            res = self.lexer.nextToken()[0] + " " + res
        lookuptoken, lookuptype = self.lexer.lookup()
        if lookuptype == ')':
            self.lexer.nextToken()
            inner = self.S()
            assert self.lexer.lookup()[1] == '('
            self.lexer.nextToken()
            name = self._generatename()
            self.addedrules[name] = inner
            res = name + " " + res
        elif lookuptype == ']':
            self.lexer.nextToken()
            inner = self.S()
            assert self.lexer.lookup()[1] == '['
            self.lexer.nextToken()
            name = self._generatename()
            self.addedrules[name] = inner + " | " # optional expression
            res = name + " " + res
        elif lookuptype == '*':
            self.lexer.nextToken()
            expr = self.A()
            name = self._generatename()
            self.addedrules[name] = expr + " " + name + " | "
            res = name + " " + res
        elif lookuptype == "+":
            self.lexer.nextToken()
            expr = self.A()
            name = self._generatename()
            self.addedrules[name] = expr + " " + name + " | " + expr
            res = name + " " + res
        return res

if __name__ == "__main__":
    oldgrammar = (l.split(":",1) for l in open("grammar.txt").read().splitlines())
    newgrammar = {}

    for head, production in oldgrammar:
        parser = ProductionParser(production)
        newgrammar[head] = parser.S()
        for k in parser.addedrules.keys(): assert k not in newgrammar
        newgrammar.update(parser.addedrules)

    for head, production in newgrammar.items():
        print(head + ": " + production)




