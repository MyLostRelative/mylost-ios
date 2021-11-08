//
//  MyLostHomeFactory.swift
//  mylost
//
//  Created by Nato Egnatashvili on 08.11.21.
//

import Components
import Core
import UIKit

protocol MyLostHomeFactory {
    func cardSections(statements: [StatementWithTaps]) -> ListSection
    func filterLabelSection(tap: ((TiTleButtonTableCell) -> Void)?, onTapSearch: ((String) -> Void)? ) -> ListSection
    func favouriteLabelSection(favTap: ((TiTleButtonTableCell) -> Void)?) -> ListSection
    func removeFilterLabelSection(filterTap: ((TiTleButtonTableCell) -> Void)?) -> ListSection
    func emptyStatementsSection() -> ListSection
    func errorStatementsSection(tap: ((ButtonWithLine) -> Void)?) -> ListSection
    func animationSection() -> ListSection
    func favouriteDialogModel(isFavourite: Bool,
                              primaryTap: ((PrimaryButton) -> Void)? ,
                              secondaryTap: ((PrimaryButton) -> Void)?) -> DialogComponent.ViewModel
}

class MyLostHomeFactoryImpl: MyLostHomeFactory {}

// MARK: - List Sections
extension MyLostHomeFactoryImpl {
    func cardSections(statements: [StatementWithTaps]) -> ListSection {
        let cardRows = statements.map({statementRow(statement: $0.statement,
                                                    isFavourite: $0.isFavourite,
                                                    favouriteTap: $0.favouriteTap,
                                                    rowTap: $0.rowTap)  })
        return ListSection(
            id: "",
            rows: cardRows)
    }
    
    func filterLabelSection(
        tap: ((TiTleButtonTableCell) -> Void)?,
        onTapSearch: ((String) -> Void)?) -> ListSection {
            ListSection(
                id: "",
                rows:  [clickableLabel(with: .init(title: "ფილტრის გამოყენება",
                                                   onTap: tap)),
                        searchTextFieldRow(onTapSearch: onTapSearch)] )
        }
    
    func favouriteLabelSection(favTap: ((TiTleButtonTableCell) -> Void)?) -> ListSection {
        let model = TiTleButtonTableCell.Model(
            title: "ფავორიტების სია",
            onTap: favTap)
        return ListSection(
            id: "",
            rows:  [clickableLabel(with: model)])
    }
    
    func removeFilterLabelSection(filterTap: ((TiTleButtonTableCell) -> Void)?) -> ListSection {
        let model = TiTleButtonTableCell.Model(
            title: "ფიტლრების წაშლა",
            onTap: filterTap)
        return ListSection(
            id: "",
            rows:  [clickableLabel(with: model)])
    }
    
    func emptyStatementsSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [emptyPageDescriptionRow()])
    }
    
    func errorStatementsSection(tap: ((ButtonWithLine) -> Void)?) -> ListSection {
        ListSection(
            id: "",
            rows:  [errorPageDescriptionRow(tap: tap)])
    }
    
    func animationSection() -> ListSection {
        ListSection(
            id: "",
            rows:  [cardAnimation(), cardAnimation(), cardAnimation()])
    }
}

// MARK: - List Rows
extension MyLostHomeFactoryImpl {
    
    private func roudCards(statements: [Statement]) -> ListSection {
        let rows = statements.map({roundCard(model: .init(title: $0.statementTitle,
                                                          description: $0.statementDescription))})
        return ListSection(
            id: "",
            rows:  rows)
    }
    
    private func roundCard(model: RoundedTitleAndDescription.ViewModel) -> ListRow <RoundCard> {
        ListRow(
            model: model,
            height: UITableView.automaticDimension)
    }
    
    private func cardAnimation() -> ListRow <CardAnimationTableCell> {
        ListRow(
            model: "",
            height: UITableView.automaticDimension)
    }
    
    private func emptyPageDescriptionRow() -> ListRow <PageDescriptionTableCell> {
        ListRow(
            model: getEmptyPageDescription,
            height: UITableView.automaticDimension)
    }
    
    private func errorPageDescriptionRow(tap: ((ButtonWithLine) -> Void)?) -> ListRow <PageDescriptionWithButtonTableCell> {
        ListRow(
            model: getErrorPgaeDescription(tap: tap),
            height: UITableView.automaticDimension)
    }
    
    private func clickableLabel(with model: TiTleButtonTableCell.ViewModel) -> ListRow<TiTleButtonTableCell> {
        ListRow(model: model,
                height: UITableView.automaticDimension)
    }
    
    private func statementRow(statement: Statement,
                              isFavourite: Bool,
                              favouriteTap: ((HeaderWithDetails) -> Void)?,
                              rowTap: ((Int, TitleAndDescriptionCardTableCell.Model, TitleAndDescriptionCardTableCell?) -> Void)?) -> ListRow <TitleAndDescriptionCardTableCell> {
        return ListRow(
            model: getCard(statement: statement,
                           isFavourite: isFavourite,
                           favouriteTap: favouriteTap),
            
            height: UITableView.automaticDimension,
            tapClosure: rowTap)
    }
    
    private func searchTextFieldRow(onTapSearch: ((String) -> Void)? ) -> ListRow <SearchTextField> {
        return ListRow(model: .init(
            title: "ძიება",
            onTapSearch: onTapSearch) ,
                       height: UITableView.automaticDimension )
    }
}

// MARK: - Rows Models
extension MyLostHomeFactoryImpl {
    private func getCard(
        statement: Statement,
        isFavourite: Bool,
        favouriteTap: ((HeaderWithDetails) -> Void)?) -> TitleAndDescriptionCardTableCell.ViewModel {
            TitleAndDescriptionCardTableCell.Model(
                headerModel: headerModel(statement: statement,
                                         isFavourite: isFavourite,
                                         favouriteTap: favouriteTap),
                cardModel: .init(title: "",
                                 description: statement.statementDescription))
        }
    
    private func headerModel(statement: Statement,
                             isFavourite: Bool,
                             favouriteTap: ((HeaderWithDetails) -> Void)?) -> HeaderWithDetailsCell.Model {
        HeaderWithDetailsCell.Model(
            icon: .withURL(url: URL(string: statement.imageUrl ?? "")),
            title: "განცხადება: " + statement.statementTitle,
            info1: "სისხლის ჯგუფი: " + (statement.bloodType?.rawValue ?? "უცნობია"),
            info2: "სქესი: " + (statement.gender?.value ?? "უცნობია"),
            info3: "ნათესაობის ტიპი: " + (statement.relationType?.value ?? "უცნობია"),
            info4: "ქალაქი: " + (statement.city ?? "უცნობია"),
            description: nil,
            rightIcon: favouriteIcon(isFavourite: isFavourite,
                                     favouriteTap: favouriteTap))
    }
    
    private func favouriteIcon(isFavourite: Bool,
                               favouriteTap: ((HeaderWithDetails) -> Void)?) -> HeaderWithDetails.RightIcon {
        .init(rightIconIsActive: isFavourite,
              rightIconActive: Resourcebook.Image.Icons24.systemStarFill.image,
              rightIconDissable: Resourcebook.Image.Icons24.systemStarOutline.image,
              rightIconHide: false,
              onTap: favouriteTap)
    }
    
    func getPostModel(tap: ((RoundedTextField) -> Void)?)-> RoundedTextFieldTableCell.Model {
        .init(placeHolderText: "დაწერეთ",
              title: "დაპოსტვა",
              onTap: tap)
    }
    
    func getCardModel(with statement: Statement) -> RoundedTitleAndDescription.ViewModel {
        RoundedTitleAndDescription.ViewModel(title: statement.statementTitle,
                                             description: statement.statementDescription)
    }
    
    var getEmptyPageDescription: PageDescription.ViewModel {
        .init(imageType: (
            image: Resourcebook.Image.Icons24.systemInfoFill.template,
            tint: Resourcebook.Color.Information.solid25.uiColor),
              title: "თქვენი არ გაქვთ განცხადებები",
              description: "თქვენი განცხადებების გვერდი ცარიელია. დაპოსტეთ განცხადება რათა განახლდეს გვერდი.")
    }
    
    func getErrorPgaeDescription(tap: ((ButtonWithLine) -> Void)? )-> PageDescriptionWithButtonTableCell.ViewModel {
        PageDescriptionWithButtonTableCell.ViewModel(pageDescriptionModel: .init(
            imageType: (image: Resourcebook.Image.Icons24.systemErrorOutline.template,
                        tint: .red),
            title: "დაფიქსირდა შეცდომა",
            description: "დაფიქსირდა შეცდომა , სცადეთ მოგვიანებით ან დააჭირეთ განახლება ღილაკს"),
                                                     buttonModel: .init(
                                                        title: "განახლება",
                                                        onTap: tap))
    }
    
    func favouriteDialogModel(isFavourite: Bool,
                              primaryTap: ((PrimaryButton) -> Void)?,
                              secondaryTap: ((PrimaryButton) -> Void)?) -> DialogComponent.ViewModel {
        let title = isFavourite ? "გაფავორიტება" : "გაფავორიტების გაუქმება"
        let description = isFavourite ? "გფავორიტების შემთხვევაში ეს განცხადება ჩაემატება ფავორიტების სიაში."
        : "ნამდვილად გსურთ, რომ წაშალოთ ეს განცხადება ფავორიტობის სიიდან? "
        return DialogComponent.ViewModel(
            imageType: (image: Resourcebook.Image.Icons24.systemInfoFill.template,
                        tint: .blue),
            title: title,
            description: description,
            firstButtonModel: .init(image: nil,
                                    title: "დიახ",
                                    backgroundCOlor: Resourcebook.Color.Positive.tr200.uiColor, titleTint: nil,
                                    onTap: primaryTap),
            secondButtonModel: .init(image: nil,
                                     title: "არა",
                                     titleTint: Resourcebook.Color.Positive.tr200.uiColor,
                                     onTap: secondaryTap))
    }
}

struct StatementWithTaps {
    let statement: Statement
    let isFavourite: Bool
    let favouriteTap: ((HeaderWithDetails) -> Void)?
    let rowTap: ((Int, TitleAndDescriptionCardTableCell.Model, TitleAndDescriptionCardTableCell?) -> Void)?
    
    public  init(statement: Statement,
                 isFavourite: Bool,
                 favouriteTap: ((HeaderWithDetails) -> Void)?,
                 rowTap: ((Int, TitleAndDescriptionCardTableCell.Model, TitleAndDescriptionCardTableCell?) -> Void)?) {
        self.statement = statement
        self.isFavourite = isFavourite
        self.favouriteTap = favouriteTap
        self.rowTap = rowTap
    }
}
