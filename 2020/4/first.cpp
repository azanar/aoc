#include <algorithm>
#include <array>
#include <boost/tokenizer.hpp>
#include <fstream>
#include <iostream>
#include <iterator>
#include <map>
#include <regex>
#include <set>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

enum PassKey {
    kByr,
    kIyr,
    kEyr,
    kHgt,
    kHcl,
    kEcl,
    kPid,
    kCid
};

typedef std::map<PassKey, std::string> entryMap;

bool is_valid(const entryMap &entries) {
    const static std::array<PassKey, 7> reqarr={kByr,kIyr,kEyr,kHgt,kHcl,kEcl,kPid};
    const static std::set<PassKey> req(reqarr.begin(), reqarr.end());
    const static std::regex heightRegex("([0-9]+)(in|cm)");
    const static std::regex hairColorRegex("#([0-9a-f]{6})");
    const static std::regex eyeColorRegex("(amb|blu|brn|gry|grn|hzl|oth)");
    const static std::regex passIDRegex("([0-9]{9})");

    for (const entryMap::value_type& k : entries) {
        unsigned long ulval;
        std::smatch match;
        switch (k.first) {
            case kByr:
                ulval = std::stoul(k.second);
                if (ulval < 1920 || ulval > 2002) {
                    return false;
                }
                break;
            case kIyr:
                ulval = std::stoul(k.second);
                if (ulval < 2010 || ulval > 2020) {
                    return false;
                }
                break;
            case kEyr:
                ulval = std::stoul(k.second);
                if (ulval < 2020 || ulval > 2030) {
                    return false;
                }
                break;
            case kHgt:
                if (!std::regex_match(k.second, match, heightRegex)) {
                        return false;
                    }
                if (match.size() != 3) {
                        return false;
                    }
                ulval = std::stoul(match[1]);
                if (match[2] == "in") {
                    if (ulval < 59 || ulval > 76) {
                        return false;
                    }
                } else if (match[2] == "cm") {
                    if (ulval < 150 || ulval > 193) {
                        return false;
                    }
                }
                break;
            case kHcl:
                if (!std::regex_match(k.second, hairColorRegex)) {
                        return false;
                    }
                break;
            case kEcl:
                if (!std::regex_match(k.second, eyeColorRegex)) {
                        return false;
                    }
                break;
            case kPid:
                if (!std::regex_match(k.second, passIDRegex)) {
                        return false;
                    }
                break;
            case kCid:
                break;
            default:
                return false;
        }
    }

    std::vector<PassKey> seen;
    std::transform(entries.cbegin(), entries.cend(),
                std::inserter(seen, seen.end()),
                    [](auto pair){ return pair.first; });
    std::vector<PassKey> missing;
    std::set_difference(req.cbegin(), req.cend(), seen.cbegin(), seen.cend(), std::inserter(missing, missing.begin()));
    if (missing.size() > 0)
        return false;
    return true;
}

int main(int argc, char* argv[]) {

    std::ifstream instr("input.txt");

    const int buflen = 100;

    std::unordered_map<std::string, PassKey> PassKeys = {
        {"byr", kByr},
        {"iyr", kIyr},
        {"eyr", kEyr},
        {"hgt", kHgt},
        {"hcl", kHcl},
        {"ecl", kEcl},
        {"pid", kPid},
        {"cid", kCid}
    };
        

    std::vector<std::array<char, buflen> > buf;

    entryMap entries;

    uint8_t valid = 0;

    /* FIXME: This misses the last passport entry */
    for(std::array<char, buflen> a; instr.getline(&a[0], buflen); ) {
        const std::string str(a.data());

        if (instr.eof() || str.empty()) {
            if(is_valid(entries))
                valid++;
            entries.clear();
        } else {


            typedef boost::tokenizer<boost::char_separator<char> > tokenizer;
            const boost::char_separator<char> sep(" ");
            tokenizer tok(str, sep);

            for( tokenizer::iterator it = tok.begin(); it != tok.end(); it++) {
                const std::string::size_type delim = it->find(":");
                const std::string key = it->substr(0, delim);
                PassKey eKey = PassKeys.at(key);
                const std::string val = it->substr(delim+1);

                entries.insert(std::make_pair(eKey, val));
            }
        }
    }

    if(is_valid(entries)) 
                valid++;

    std::cout << "thing: " << static_cast<unsigned int>(valid) << std::endl;
}

