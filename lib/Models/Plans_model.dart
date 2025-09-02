// To parse this JSON data, do
//
//     final plansModel = plansModelFromJson(jsonString);

import 'dart:convert';

PlansModel plansModelFromJson(String str) => PlansModel.fromJson(json.decode(str));


class PlansModel {
    int ?status;
    List<Plan> ?plan;

    PlansModel({
         this.status,
         this.plan,
    });

    factory PlansModel.fromJson(Map<String, dynamic> json) => PlansModel(
        status: json["status"],
        plan: List<Plan>.from(json["plan"].map((x) => Plan.fromJson(x))),
    );

    
}

class Plan {
    String ?uniqueId;
    String ?planName;
    String ?costOpeningAccount;
    String ?monthlyIbanCost;
    String ?description;
    String ?sepaInFee;
    String ?sepaInFeePercentage;
    String ?sepaInstantInFee;
    String ?sepaInstantInFeePercentage;
    String ?sepaOutFee;
    String ?sepaOutFeePercentage;
    String ?sepaInstantOutFee;
    String ?sepaInstantOutFeePercentage;
    String ?selected;

    Plan({
         this.uniqueId,
         this.planName,
         this.costOpeningAccount,
         this.monthlyIbanCost,
         this.description,
         this.sepaInFee,
         this.sepaInFeePercentage,
         this.sepaInstantInFee,
         this.sepaInstantInFeePercentage,
         this.sepaOutFee,
         this.sepaOutFeePercentage,
         this.sepaInstantOutFee,
         this.sepaInstantOutFeePercentage,
         this.selected,
    });

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        uniqueId: json["unique_id"],
        planName: json["plan_name"],
        costOpeningAccount: json["cost_opening_account"],
        monthlyIbanCost: json["monthly_iban_cost"],
        description: json["description"],
        sepaInFee: json["sepa_in_fee"],
        sepaInFeePercentage: json["sepa_in_fee_percentage"],
        sepaInstantInFee: json["sepa_instant_in_fee"],
        sepaInstantInFeePercentage: json["sepa_instant_in_fee_percentage"],
        sepaOutFee: json["sepa_out_fee"],
        sepaOutFeePercentage: json["sepa_out_fee_percentage"],
        sepaInstantOutFee: json["sepa_instant_out_fee"],
        sepaInstantOutFeePercentage: json["sepa_instant_out_fee_percentage"],
        selected: json["selected"],
    );

    Map<String, dynamic> toJson() => {
        "unique_id": uniqueId,
        "plan_name": planName,
        "cost_opening_account": costOpeningAccount,
        "monthly_iban_cost": monthlyIbanCost,
        "description": description,
        "sepa_in_fee": sepaInFee,
        "sepa_in_fee_percentage": sepaInFeePercentage,
        "sepa_instant_in_fee": sepaInstantInFee,
        "sepa_instant_in_fee_percentage": sepaInstantInFeePercentage,
        "sepa_out_fee": sepaOutFee,
        "sepa_out_fee_percentage": sepaOutFeePercentage,
        "sepa_instant_out_fee": sepaInstantOutFee,
        "sepa_instant_out_fee_percentage": sepaInstantOutFeePercentage,
        "selected": selected,
    };
}
