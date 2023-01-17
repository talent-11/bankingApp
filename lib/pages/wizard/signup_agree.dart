import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fotoc/components/ui/logo_bar.dart';
import 'package:fotoc/components/wizard/bullet_row.dart';
import 'package:fotoc/components/wizard/button.dart';
import 'package:fotoc/components/wizard/dots.dart';
import 'package:fotoc/components/wizard/emphatic_row.dart';
import 'package:fotoc/components/wizard/text_with_cc.dart';
import 'package:fotoc/pages/wizard/sidebar.dart';

class SignupAgreePage extends StatefulWidget {
  const SignupAgreePage({Key? key}) : super(key: key);

  @override
  State<SignupAgreePage> createState() => _SignupAgreePageState();
}

class _SignupAgreePageState extends State<SignupAgreePage> {
  void onPressedNext(BuildContext context) {
    // Navigator.pushNamed(context, '/wizard/signup/start');
    Navigator.pushNamed(context, '/free/verify/3');
  }

  void onPressedCancel(BuildContext context) {
    exit(0);
  }

  Padding commonRow(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextWithCC(text: text)
  );

  Widget bulletRow(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: BulletRow(text: text),
  );

  Widget emphaticRow(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: EmphaticRow(text: text, fontWeight: FontWeight.bold,),
  );

  Widget body(BuildContext context) => Expanded(
    flex: 1,
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      children: [
        commonRow(context, "Once again in the course of human events, 245 Years + 2 days after the Declaration of Independence was adopted (July 4th, 1776), it becomes necessary for one people to dissolve the political bands that connect them with another. We therefore declare that all leadership of the FEDERAL GOVERNMENT be dismissed from their posts, positions, employment, etc., elected or otherwise; and We the People, assert our rights—granted by the laws of Nature and secured through the Constitution for the United States—to restore and reestablish our government in accordance with the original intents of our Founding Fathers. We acknowledge that the grounds for such removal must be reasonable, and a decent respect for the opinions of mankind requires that we should declare the causes which impel us towards that removal."),
        commonRow(context, "We hold these truths to be self-evident, that all men and women are created equal, that they are endowed by their Creator with certain unalienable Rights; that among these are Life, Liberty and the pursuit of Happiness. That to secure these rights, Governments are instituted among the People, deriving their just powers from the consent of the governed. That whenever any Form of Government becomes destructive of these ends, it is the Right of the People to alter or to restore it, and to institute newly elected Government officers, officials and workers, restoring its foundation on such principles and restoring its powers in such form, as to them shall seem most likely to effect their Safety and Happiness. Prudence, indeed, will dictate that Governments long established should not be changed for light and transient causes; and accordingly all experience has shown, that the Citizenry is more disposed to suffer, while evils are sufferable, than to right themselves by restoring the form of government conceived and formed by our Founding Fathers over 234 years ago. But when a long train of abuses, thieves and secret alliances; usurpations and secret subjugations evinces a design to reduce them under greed, corruption, malpractice, and creeps ever forward towards despotism, it is the People’s right—it is their duty—to throw off such Government, to restore its function as an instrument of the governed, who shall effect new safe guards and new amendments for their future security. The history of the present so-called FEDERAL GOVERNMENT is a history of repeated secrecy, injuries, usurpations, corruption, theft, malpractice, and despotism, all having in direct object the establishment of self-service, money and power, over and above service to these States and to the people; its rightful masters."),
        commonRow(context, "To prove this, let these Facts be submitted to a candid world:"),
        bulletRow(context, "They conspired to form a “Legal Fiction” or “FEDERAL” Corporation called THE UNITED STATES to secretly “go around” the Constitutional Government that We the People ordained by the hands of our Founding Fathers."),
        bulletRow(context, "They conspired to form a “Legal Fiction” or “FEDERAL” corporation called the CONSTITUTION OF THE UNITED STATES OF AMERICA to secretly “go around” the original Constitution for the United States of America. They created this “Legal Fiction” or “secret jurisdiction” to subjugate us, override our Rights and Liberties and to fulfill their nefarious objectives of monopoly, greed, tyranny, monarchy and control."),
        bulletRow(context, "They are allowing the secret, subtle and gradual dismantling of our Constitutional Republic and the installation of a monarchy (or oligarchy)."),
        bulletRow(context, "They are participating in Collusion, Conspiracy, Fraud, False Pretense, Racketeering and other secret and nefarious activities with the objective and end goals of money, power and total control."),
        bulletRow(context, "They are allowing corporate monopolies such as the AMA, Big Pharma, the CDC, Big Oil, Big Tech, the FEDERAL RESERVE and others to dictate, dominate and control industries."),
        bulletRow(context, "They are allowing and even participating in conspiracies to subvert Liberty and the Constitution. They are destroying Free Speech, Freedom of the Press, Freedom to Assemble, Freedom of Choice to name a few, which are unalienable rights (rights that cannot be taken or given away)."),
        bulletRow(context, "They are Mandating, Ordering, Restricting, Prohibiting (Abridging) and blatantly enforcing these so-called “laws” and rules upon We the People without “Due Process of Law,” which is completely and undeniably unconstitutional. (See 4th Amendment)."),
        bulletRow(context, "The Constitution guarantees our unalienable rights (rights that cannot be taken or given away). It specifically states that “congress shall make no laws” to “prohibit” “infringe” or “abridge” our rights! Synonyms that best represent our modern day vernacular are “restrict” “restriction” “ban” “restrain” “prevent” “interrupt” “lessen” “limit” “diminish” and “mandate!” Yet today, our “authorities” are issuing or decreeing “bans” “orders” “mandates” and “restrictions!” They’re “prohibiting” what we can’t do and “limiting” what we can do! They’re restricting this activity or that activity decreeing what’s essential and what’s “non-essential!” They’re threatening us with “misdemeanors” and “fines” for violating their “restrictions!” This is blatant abuse of our unalienable rights and the Constitution! None of these “bans” “orders” “mandates” and “restrictions” are Constitutional and everyone upholding such are in violation of their Oath of Office to uphold and sustain the Constitution!"),
        bulletRow(context, "They have legalized bribery and call it “Lobbying.” They change the definition and meaning of words to suit their nefarious objectives."),
        bulletRow(context, "They have given financial control of our country to a private bank (the Federal Reserve Bank), which operates only for the increase and gain of itself and its alliances. They have allowed the currency of this country to be monetized by debt and backed by nothing but the hard work of its Citizens."),
        bulletRow(context, "They have allowed greed, money and power to take priority over their sworn oath to uphold and sustain the Constitution."),
        bulletRow(context, "They have made reelection a priority over service to their constituents, and have sold their votes to realize this goal."),
        bulletRow(context, "They have abused and restricted (abridged) our freedoms and liberty in the name of “National Security” or “Safety.”"),
        bulletRow(context, "They put their alliance’s objectives over and above the good of the people."),
        bulletRow(context, "They have, by all appearances, abandoned honesty, integrity, respect, and civility in favor of strategies, talking points, and political maneuvering."),
        bulletRow(context, "They have recklessly spent our monies beyond our means of income by more than 28 Trillion dollars, endangering the economic stability of this country and the futures of our children."),
        bulletRow(context, "They have circumvented the legislative process and expanded the scope of executive orders, thereby rendering the legislative checks and balances envisioned by our Founders irrelevant."),
        bulletRow(context, "They have installed Judges who adjudicate according to political alliances, influence pandering, and other pressures rather than upholding the Constitution."),
        bulletRow(context, "They have passed laws and enacted legislative rules that facilitate extravagant lifestyles for themselves and their families, with huge benefits and retirements."),
        bulletRow(context, "They have poorly managed the laws for naturalization of foreigners, refusing to protect our borders and discouraging immigration by making it too difficult to be eligible to immigrate to these United States."),
        bulletRow(context, "They have imposed taxes on us without our consent and without a Constitutional amendment."),
        bulletRow(context, "They have not “apportioned” taxes fairly as originally intended by Article 1 section 2 of the original Constitution. They are using “Internal Revenue Service” agents, the FDA, the FTC, the CDC, the EPA, the BLM, FEMA and other unconstitutional agencies to harass and inflict injuries to law-abiding Citizens, to their livelihoods, etc."),
        bulletRow(context, "They have carried out so-called pre-emptive military actions without the approval of the legislature, as it requires in the original Constitution."),
        bulletRow(context, "They have enforced certain parts of laws, but ignored others, arbitrarily and without accountability."),
        bulletRow(context, "They have ignored or broken laws and have not been held accountable."),
        bulletRow(context, "They have and are participating in Conspiracy, Monopoly and Anti-Competitive behaviors by promoting one industry and suppressing or eliminating their alliance’s competition."),
        bulletRow(context, "They have created “legislative rules” to manipulate the manner in which bills become laws, and to create obstacles preventing some bills from ever becoming law."),
        bulletRow(context, "They deny bills that have passed committee from being voted upon depending upon the whims or decision of the leader of the respective division of the legislature."),
        bulletRow(context, "They pass laws that are written in impenetrable language, burdened with thousands of pages of code and confusing legalese, which facilitates loopholes and keeps the law inaccessible to the governed."),
        bulletRow(context, "They have passed laws forcing (mandating) Citizens to purchase a product or a service."),
        bulletRow(context, "They have enacted laws to aid in the establishment of “political careers,” contrary to the founding fathers’ intent for those elected to serve the people and to have short terms."),
        commonRow(context, "We now remind them of the ultimate governing power, given to us by God, that “We the People” collectively hold and our right to rescind the power we have delegated to them. We declare our power, authority, and right to restore the Constitution and to call for, organize, and hold a Constitutional Convention & Court for this purpose. We disavow their usurpations. They have been deaf to our voices. We declare our authority and power to remove all of them from office."),
        bulletRow(context, "We the People exercise our collective authority and hereby rescind and revoke the following LEGAL FICTIONS: the FEDERAL CORPORATION A.K.A. “THE UNITED STATES” and their FEDERAL CORPORATION A.K.A “CONSTITUTION OF THE UNITED STATES OF AMERICA” and all the other LEGAL FICTIONS created by them (“FEDERAL GOVERNMENT”) and all of their authority."),
        bulletRow(context, "We hereby revoke our consent to the jurisdiction of and the governance by the Defendant the “FEDERAL GOVERNMENT”."),
        bulletRow(context, "We hereby revoke our signatures from any and ALL contracts either knowingly or unknowingly entered into under the legal fiction and “FEDERAL STATE” collectively known and called hereafter as the “FEDERAL GOVERNMENT”."),
        bulletRow(context, "We the People revoke ALL Executive Orders by any President or Governor, past or present!"),
        bulletRow(context, "We the People revoke the legal fiction FEDERAL GOVERNMENT and declare our intentions to remove, rescind, and eliminate all leadership positions, elected or otherwise (stations) and replace according to the plan as set forth in the book “MAP OF THIEVES” by Scott Workman."),
        bulletRow(context, "We revoke our consent and hereby nullify any further authority granted to WASHINGTON D.C., and or the FEDERAL GOVERNMENT and command you to sit still and maintain the basic operations of our government until the majority of States and We the People agree on the plan aforementioned to reinstall the Constitutional Republic form of government that has been stolen, obscured, subverted and supplanted by your conspiracy and fraudulent actions under the legal fiction FEDERAL CORPORATE STATE A.K.A the “FEDERAL GOVERNMENT”!"),
        bulletRow(context, "All defendants in the FEDERAL GOVERNMENT, listed in our lawsuit, who have sworn an oath to uphold and sustain the CONSTITUTION OF THE UNITED STATES OF AMERICA, have sworn an oath to uphold and sustain a FOREIGN CORPORATION’S CONSTITUTION. This constitutes grounds for immediate dismissal and prosecution for crimes against We the People and the original Constitution and depending upon the severity of the actions of the defendants constitutes treason. At the very least, all the defendants immediately have no more standing or authority in any way shape or form. All leadership will be removed from their respective stations at the Constitutional Convention & Court. Any non-defendant FEDERAL EMPLOYEE that desires to retain their employment with the restored Constitutional Government will be required to be retrained, repositioned and take an oath to defend and sustain the Constitution for the United States of America. (See Complaint/Lawsuit for further details)."),
        commonRow(context, "We, therefore, appealing to the world for the rectitude of our intentions, do, in the Name, and by the Authority of God, and the good People of these States, solemnly publish and declare, that these United States are, and of Right must be, Free and Independent from those who would exploit our system of government; that we have full Power to restore our government to one that is Of the People, By the People and For the People. And for the support of this Declaration, with a firm reliance on the protection and authorities secured by our original Constitution, we mutually pledge to each other our Lives, our Fortunes and our sacred Honor."),
        commonRow(context, "I, (Fill in your Name Below) hereby revoke my signature on all contracts with the FEDERAL CORPORATION A.K.A THE UNITED STATES A.K.A the FEDERAL GOVERNMENT and give my consent to be a Plaintiff in the lawsuit commenced by Friends of the Original Constitution® against the FEDERAL GOVERNMENT, et al., (over 140 other defendants) to obtain all objectives, actions, discovery, injunctions, reliefs and results as set forth within the said lawsuit. I demand and give my authorization as a Citizen of the United States of America to call for and hold a Constitutional Convention as prescribed in Article V of the original United States Constitution NOT to throw out the Constitution and start from scratch, and the delegates are NOT granted any authority to do this, BUT the purpose of the Convention WILL BE to follow in accordance the specific and detailed plan of action as set forth in the following (3) documents by Scott Workman: 1- Book: “MAP OF THIEVES”; 2- Book: The Trojan Virus; 3- Complaint/Lawsuit against the FEDERAL CORPORATION A.K.A THE UNITED STATES and over 140 MONOPOLISTS; namely to restore the Constitutional Government fraudulently usurped by the FEDERAL CORPORATION A.K.A THE UNITED STATES. I authorize Scott Workman as the Founder of this movement to be the First Delegate at the Constitutional Convention & Court; to commence the lawsuit; to represent me in his Nonlawyer capacity as well as do all functions necessary including but not limited to soliciting, gathering and posting evidence, to issuing subpoenas, to demand documents from the defendants for discovery; service of process, issuance of injunctions and Cease and Desist Orders and to adjudicate in all aforementioned matters prior to the Constitutional Convention & Court and to be one of the delegate judges and the General Council Chairman (“Chair”) at the Constitutional Convention & Court."),
        commonRow(context, "I affirm with an oath to uphold Liberty, defend the true Constitution and sustain the Constitutional Laws of this land and pledge my allegiance to the Constitutional Government and this movement to fully restore and reestablish the Constitutional Government at the Constitutional Convention & Court."),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 48,
                  child: FotocButton(
                    outline: true,
                    buttonText: "Disagree",
                    onPressed: () {
                      onPressedCancel(context);
                    },
                  ),
                )
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 48,
                  child: FotocButton(
                    buttonText: "Agree to All",
                    onPressed: () {
                      onPressedNext(context);
                    },
                  ),
                )
              ),
            ]
          ),
        ),
        const Dots(selectedIndex: 4, dots: 6),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SideBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            const LogoBar(),
            body(context)
          ],
        ),
      ),
    );
  }
}
