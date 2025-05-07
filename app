'use client';
import { useState } from 'react';

export default function GodCodePlayground() {
  const [input, setInput] = useState("BEGIN CREATION\n  DECLARE seeker AS worthy\n  IF seeker IS worthy THEN REVEAL(\"truth\") ELSE REVEAL(\"test\")\n  ASCEND\nEND CREATION");
  const [output, setOutput] = useState("");

  const interpretGodCode = (code) => {
    const lines = code.split("\n");
    const env = {};
    let result = "";

    for (let rawLine of lines) {
      const line = rawLine.trim();

      if (line.startsWith("DECLARE")) {
        const [_, varName, __, ...valueParts] = line.split(" ");
        env[varName] = valueParts.join(" ");
        result += `[DECLARE] ${varName} set to ${env[varName]}\n`;
      }
      else if (line.startsWith("IF") && line.includes("THEN")) {
        const [condPart, thenPartRaw] = line.split("THEN");
        const thenPart = thenPartRaw.includes("ELSE") ? thenPartRaw.split("ELSE")[0].trim() : thenPartRaw.trim();
        const elsePart = thenPartRaw.includes("ELSE") ? thenPartRaw.split("ELSE")[1].trim() : null;

        const condition = condPart.replace("IF", "").trim();
        const [subject, isWord, expected] = condition.split(" ");
        if (env[subject] === expected) {
          result += `[IF] Condition TRUE → ${thenPart}\n`;
        } else if (elsePart) {
          result += `[IF] Condition FALSE → ${elsePart}\n`;
        } else {
          result += `[IF] Condition FALSE → No Action\n`;
        }
      }
      else if (line.startsWith("REVEAL")) {
        const revealed = line.substring(line.indexOf("(") + 1, line.indexOf(")")).replace(/\"/g, "");
        result += `[REVEAL] ${revealed}\n`;
      }
      else if (line.startsWith("ASCEND")) {
        result += `[ASCEND] Block Complete\n`;
      }
      else if (line.startsWith("BEGIN CREATION")) {
        result += `[BEGIN] New Creation\n`;
      }
      else if (line.startsWith("END CREATION")) {
        result += `[END] Creation Closed\n`;
      }
    }
    return result;
  };

  const handleRun = () => {
    const interpreted = interpretGodCode(input);
    setOutput(interpreted);
  };

  return (
    <div className="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <h2 className="text-xl font-bold mb-2">🧠 Write God Code</h2>
        <textarea
          className="w-full h-96 p-4 border rounded-xl shadow"
          value={input}
          onChange={(e) => setInput(e.target.value)}
        />
        <button
          onClick={handleRun}
          className="mt-4 bg-black text-white px-4 py-2 rounded-xl hover:bg-gray-800"
        >
          Run God Code
        </button>
      </div>

      <div>
        <h2 className="text-xl font-bold mb-2">📜 Output</h2>
        <pre className="bg-gray-100 p-4 rounded-xl h-96 overflow-auto whitespace-pre-wrap">
          {output}
        </pre>
      </div>
    </div>
  );
}
