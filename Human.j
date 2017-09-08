
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;


public class Solution {
    public static void main(String[] args) throws ParseException{
        Human dad = new Human("Сергей", "Трубецкой", true, "24.09.89");
        Human mom = new Human("Ольга", "Чуркина", false, "09.02.90");
        Human kid = new Human("Петька", true, "12.08.2010", mom, dad);
        Human kid2 = new Human("Танька", false, "13.09.11", mom, dad);
        System.out.println(Human.population.get(3));

    }

    public static class Human {

        private String firstName;
        private String familyName;
        private String fatherName;
        private boolean sex;
        private Date birthDate = new Date();
        private Human mother;
        private Human father;
        private ArrayList<Human> children = new ArrayList<>();

        private static SimpleDateFormat dfIn = new SimpleDateFormat("dd'.'MM'.'yy");
        private static SimpleDateFormat dfOut = new SimpleDateFormat("d' 'MMMMM ' 'yyyy");
        private static ArrayList<Human> population = new ArrayList<>();

        public Human(String firstName, String fatherName, String familyName, boolean sex, Date birthDate, Human mother, Human father) {
            this.firstName = firstName;
            this.fatherName = fatherName;
            this.familyName = familyName;
            this.sex = sex;
            this.birthDate = birthDate;
            this.mother = mother;
            this.father = father;
            population.add(this);
        }

        public Human(String firstName, String familyName, boolean sex, Date birthDate){
            this(firstName, null, familyName, sex, birthDate, null, null);
        }

        public Human(String firstName, String familyName, boolean sex, String birthDate) throws ParseException {
            this(firstName, familyName, sex, dfIn.parse(birthDate));
        }

        public Human(String firstName, boolean sex, Date birthDate, Human mother, Human father) {
            this(firstName, null, null, sex, birthDate, mother, father);
            this.familyName = makeFamilyName();
            this.fatherName = makeFatherName();
            this.father.children.add(this);
            this.mother.children.add(this);
        }

        public Human(String firstName, boolean sex, String birthDate, Human mother, Human father) throws ParseException {
            this(firstName, sex, dfIn.parse(birthDate), mother, father);
        }

        private String makeFamilyName(){
            /*
            Образует фамилию из фамилии отца в зависимости от пола
             */
            String s = father.familyName;
            int length = s.length();
            if (!sex && length > 2){
                String s2 = s.substring(length - 2);
                if (s2.equals("ин")||s2.equals("ов")||s2.equals("ев")){
                    return s.concat("а");
                }else if(s.substring(length - 3).equals("кий") || s2.equals("ой") || s2.equals("ый")) {
                    return s.substring(0, length - 2).concat("ая");
                }else if (s2.equals("ий")){
                    return s.substring(0, length - 2).concat("яя");
                }else return s;
            }else return s;
        }

        private String makeFatherName() {
            /*
            Образует отчество из имени отца в зависимости от пола.
            Сначала имена-исключения, затем то, что по правилам.
             */
            String fn = father.firstName;
            int length = fn.length();
            switch (fn) {
                case "Георгий":
                    return sex?"Георгиевич":"Георгиевна";
                case "Гаврила":
                    return sex?"Гаврилович":"Гавриловна";
                case "Данила":
                    return sex?"Данилович":"Даниловна";
                case "Дмитрий":
                    return sex?"Дмитриевич":"Дмитриевна";
                case "Илья":
                    return sex?"Ильич":"Ильинична";
                case "Лев":
                    return sex?"Львович":"Львовна";
                case "Никита":
                    return sex?"Никитич":"Никитична";
                case "Павел":
                    return sex?"Павлович":"Павловна";
                default:
                    if (length > 2) {
                        String s2 = fn.substring(length - 2);
                        String s1 = fn.substring(length - 1);
                        if (s2.equals("ий")) {
                            return fn.substring(0, length - 2).concat(sex?"ьевич":"ьевна");
                        } else if (s2.equals("ей") || s2.equals("ай") || s1.equals("ь")) {
                            return fn.substring(0, length - 1).concat(sex ? "евич" : "евна");
                        } else if (s1.equals("а")) {
                            return fn.substring(0, length - 1).concat(sex ? "ич" : "инична");
                        } else {
                            return fn.concat(sex?"ович":"овна");
                        }
                    } else return fn.concat(sex?"ович":"овна");
            }
        }


        private String getFullName(){return familyName +" "+ firstName + (fatherName!=null?" "+fatherName:"");}


        public String toString(){
            String toString =  getFullName() + "\n" +
                    "Пол: " + (sex?"мужской":"женский") + ". Дата рождения: " + dfOut.format(birthDate) + "." + "\n";
            if(father != null && mother != null) toString += "Отец: " + father.getFullName() + ".\nМать: " + mother.getFullName() + ".\n";
            else if(father == null && mother == null) toString += "Сирота.\n";
            else if(father == null) toString += "Мать: " + mother.getFullName() + ".\nОтца не имеет\n";
            else toString += "Отец: " + father.getFullName() + ".\nМатери не имеет.\n";

            if(!children.isEmpty()) {
                toString += "Дети: ";
                for (int i = 0; i < children.size(); i++){
                    toString += children.get(i).getFullName() + (i < children.size()-1?", ":"");
                }
                toString += ".\n";
            }else toString += "Детей не имеет.\n";
            return toString;
        }
    }
}
